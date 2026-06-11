# Implementation Runbook

This file documents the commands and decisions needed to rebuild or continue this project from scratch. It should be updated whenever a console command changes the local project, GCP infrastructure, database state, deployment configuration, or billing footprint.

## Project Context

- Application: Django web app for DB_QueryMinds.
- App directory: `query_minds_project_web_app/`
- Local Python environment: `venv/`
- Database: MySQL, expected by Django settings.
- Deployment target: Google App Engine standard environment.
- Main GCP paid resource: Cloud SQL for MySQL.

## 1. Check Repository State

Run from the project root:

```bash
git status
```

Impact:

- Shows whether there are uncommitted local changes.
- Helps avoid overwriting work before changing settings, environment files, or deployment files.

Optional inspection commands:

```bash
git branch
git log --oneline -5
```

Impact:

- Confirms the active branch.
- Shows the most recent commits before continuing work.

## 2. Check Local Environment

Run from the project root:

```bash
source venv/bin/activate
python --version
pip list
```

Impact:

- Activates the existing Python virtual environment.
- Confirms Python and installed package versions.
- Helps verify whether dependencies are already available before reinstalling anything.

Check Django:

```bash
cd query_minds_project_web_app
python manage.py check
```

Impact:

- Confirms the Django app loads successfully.
- Does not require a successful database connection for basic project validation.

Check environment files:

```bash
ls -la .env ../.env
```

Impact:

- Confirms local environment files exist.
- These files may contain secrets and should not be printed to the terminal or committed.

## 3. Check GCP CLI Setup

Run:

```bash
gcloud --version
gcloud auth list
gcloud config list
```

Impact:

- Confirms the Google Cloud SDK is installed.
- Shows which account and project are active.

Set the intended project:

```bash
gcloud config set project queryminds
```

Impact:

- Makes future `gcloud` commands target the `queryminds` project by default.
- Prevents accidentally creating resources in the wrong project.

Enable required APIs:

```bash
gcloud services enable sqladmin.googleapis.com
```

Impact:

- Enables Cloud SQL Admin API.
- Required before creating or managing Cloud SQL instances.

## 4. Confirm Existing Service Accounts

Known existing service accounts:

```text
App Engine default service account
Compute Engine default service account
```

Impact:

- No new service account is required unless the project needs stricter production-style permission separation.
- App Engine commonly uses the App Engine default service account when the Django app is deployed.
- Compute Engine default service account is commonly used by VM-based workloads and is not required for the local Django run.
- Service accounts do not directly create billing charges, but the resources they can create or access can incur costs.

Recommended check:

```bash
gcloud iam service-accounts list
```

Impact:

- Confirms the service accounts available in the active GCP project.
- Helps avoid creating duplicate or unnecessary identities.

## 5. Create Low-Cost Cloud SQL Instance

Command used/planned:

```bash
gcloud sql instances create neu-db-project \
  --database-version=MYSQL_8_0 \
  --tier=db-f1-micro \
  --region=us-west2 \
  --storage-size=10GB \
  --availability-type=ZONAL
```

Purpose:

- Creates a Google Cloud SQL for MySQL instance named `neu-db-project`.
- Provides the managed MySQL database required by the Django app.
- Uses `us-west2`, which is geographically close to San Jose, CA.

Impact:

- Starts recurring Cloud SQL billing.
- Creates a low-cost MySQL 8.0 instance using `db-f1-micro`.
- Uses 10GB storage for a class/demo workload.
- Uses zonal availability to avoid the additional cost of high availability.

Cost notes:

- Stop the instance when not in use to reduce compute charges.
- Storage and backup charges may continue even when stopped.
- Track expected billing in `billing.md`.

## 6. Verify Cloud SQL Configuration

Run:

```bash
gcloud sql instances describe neu-db-project \
  --format="yaml(name,connectionName,region,state,settings.tier,settings.dataDiskSizeGb,settings.availabilityType,settings.backupConfiguration.enabled,settings.activationPolicy)"
```

Impact:

- Confirms the instance exists.
- Captures the real `connectionName` needed by App Engine and Cloud SQL Proxy.
- Confirms cost-sensitive settings such as tier, storage, availability, backups, and activation policy.

## 7. Create Database and User

Current status: done in GCP.

Create the database expected by Django:

```bash
gcloud sql databases create neu_db_project \
  --instance=neu-db-project \
  --charset=utf8mb4 \
  --collation=utf8mb4_unicode_ci
```

Impact:

- Creates the application database used by Django.
- Must match the `NAME` value in Django `DATABASES` settings.

Create the database user:

```bash
gcloud sql users create neu-db-user \
  --instance=neu-db-project \
  --host=% \
  --password='NEW_STRONG_PASSWORD'
```

Impact:

- Creates the MySQL user used by Django.
- The password must be stored securely in local `.env`, GCP Secret Manager, or another secret management path.
- Do not commit the password to git.

## 8. Restore Database Dump

Current status: done in GCP. Tables were checked and confirmed populated.

Available local dumps:

```text
DB_dumps/schema_data_dump_04_05_2025.sql
DB_dumps/schema_dump_04_05_2025.sql
DB_dumps/data_dump_04_05_2025.sql
DB_dumps/sing_tranc_schema_data_dump_04_05_2025.sql
```

Recommended full restore file:

```text
DB_dumps/schema_data_dump_04_05_2025.sql
```

Create a temporary import bucket:

```bash
gcloud storage buckets create gs://YOUR_UNIQUE_BUCKET_NAME --location=us-west2
```

Impact:

- Creates a Cloud Storage bucket so Cloud SQL can import the SQL dump.
- This can incur small storage costs until deleted.

Upload the dump:

```bash
gcloud storage cp DB_dumps/schema_data_dump_04_05_2025.sql \
  gs://YOUR_UNIQUE_BUCKET_NAME/schema_data_dump_04_05_2025.sql
```

Impact:

- Copies the local SQL dump to Cloud Storage.
- Required because Cloud SQL imports SQL files from Cloud Storage.

Find the Cloud SQL service account:

```bash
gcloud sql instances describe neu-db-project \
  --format="value(serviceAccountEmailAddress)"
```

Impact:

- Gets the service account that needs permission to read/import the SQL dump.

Grant bucket access:

```bash
gcloud storage buckets add-iam-policy-binding gs://YOUR_UNIQUE_BUCKET_NAME \
  --member=serviceAccount:SERVICE_ACCOUNT_EMAIL \
  --role=roles/storage.objectViewer
```

Impact:

- Allows Cloud SQL to read the dump from Cloud Storage.

Import the dump:

```bash
gcloud sql import sql neu-db-project \
  gs://YOUR_UNIQUE_BUCKET_NAME/schema_data_dump_04_05_2025.sql \
  --database=neu_db_project
```

Impact:

- Restores the database schema and data into Cloud SQL.
- Makes the database usable by the Django app.

## 9. Configure Django Database Connection

Relevant file:

```text
query_minds_project_web_app/query_minds_project_web_app/settings.py
```

Current expected values:

```text
Database name: neu_db_project
Database user: neu-db-user
Database engine: django.db.backends.mysql
```

Impact:

- Django must point to the correct database host, user, password, and database name.
- For local development through Cloud SQL Proxy, use host `127.0.0.1` and the proxy port.
- For App Engine, prefer Cloud SQL connection settings and environment variables instead of hard-coded secrets.

Current local configuration:

```text
DB_NAME=neu_db_project
DB_USER=neu-db-user
DB_HOST=127.0.0.1
DB_PORT=3306
```

Impact:

- Local Django runs connect through the Cloud SQL Auth Proxy instead of the Cloud SQL public IP.
- The proxy must be running before `python manage.py runserver`.
- Database credentials are loaded from `.env` instead of being hard-coded in Django settings.

## 10. Run Locally

Activate the environment and start Django:

```bash
source venv/bin/activate
cd query_minds_project_web_app
python manage.py runserver
```

Impact:

- Starts the local Django development server.
- Local URL is usually `http://127.0.0.1:8000`.
- Pages that access the database require working Cloud SQL or local MySQL connectivity.

## 11. Cost Control Commands

Stop Cloud SQL when not in use:

```bash
gcloud sql instances patch neu-db-project --activation-policy=NEVER
```

Impact:

- Stops the Cloud SQL instance from running continuously.
- Reduces compute-related charges.
- Storage and backup charges may still continue.

Start Cloud SQL again:

```bash
gcloud sql instances patch neu-db-project --activation-policy=ALWAYS
```

Impact:

- Restarts Cloud SQL availability for local development or deployed app usage.
- Compute-related charges resume.

## 12. Command Impact Log

| Date | Command | Impact |
| --- | --- | --- |
| 2026-06-10 | `gcloud sql instances create neu-db-project --database-version=MYSQL_8_0 --tier=db-f1-micro --region=us-west2 --storage-size=10GB --availability-type=ZONAL` | Created the low-cost Cloud SQL MySQL instance required for the app database. Starts recurring Cloud SQL billing. |
| 2026-06-10 | Created `neu_db_project` database and `neu-db-user` in Cloud SQL | Database and application user now exist in GCP for the Django app. |
| 2026-06-10 | Restored/imported SQL data and verified populated tables | Cloud SQL database now has project schema/data and is ready for application connectivity testing. |
| 2026-06-10 | Updated Django database settings to read `DB_*` values from `.env` and default `DB_HOST` to `127.0.0.1` | Local app runs now target the Cloud SQL Auth Proxy instead of the public Cloud SQL IP. |

## Maintenance Rule

Whenever a command changes project state, add it to the command impact log with:

- Date
- Exact command
- Why it was run
- What changed
- Any billing, security, or deployment impact
