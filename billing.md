# Billing Tracker

This file tracks GCP resources that can incur costs for this project, along with rough cost drivers and estimates over time.

## Active Cost Resources

| Resource | Service | Region | Configuration | Cost Drivers | Status |
| --- | --- | --- | --- | --- | --- |
| `neu-db-project` | Cloud SQL for MySQL | `us-west2` | MySQL 8.0, `db-f1-micro`, 10GB storage | Instance uptime, storage, backups, network egress | Active |

## Current Estimate

### Cloud SQL: `neu-db-project`

Assumptions:

- Region: `us-west2`
- Database version: MySQL 8.0
- Machine tier: `db-f1-micro`
- Storage: 10GB
- Availability: zonal/single-zone
- Backup storage: minimal or disabled
- Usage pattern: temporary class/demo workload

Estimated cost pattern:

| Usage Pattern | Expected Cost Behavior |
| --- | --- |
| Running 24/7 | Highest recurring cost because Cloud SQL charges while the instance is active |
| Running only during development | Lower cost if the instance is stopped when not in use |
| Storage retained while stopped | Storage can continue incurring cost even when the instance is stopped |
| High availability enabled | Higher cost due to regional/standby resources |
| Backups retained | Additional backup storage cost |

## Cost Control Actions

Use these commands when the database is not needed:

```bash
gcloud sql instances patch neu-db-project --activation-policy=NEVER
```

Use this command to start the database again:

```bash
gcloud sql instances patch neu-db-project --activation-policy=ALWAYS
```

Check the current cost-relevant configuration:

```bash
gcloud sql instances describe neu-db-project \
  --format="yaml(region,settings.tier,settings.dataDiskSizeGb,settings.availabilityType,settings.backupConfiguration.enabled,settings.activationPolicy)"
```

## Cost Log

| Date | Resource | Change | Expected Billing Impact |
| --- | --- | --- | --- |
| 2026-06-10 | `neu-db-project` | Created Cloud SQL MySQL instance with `db-f1-micro` and 10GB storage in `us-west2` | Starts recurring Cloud SQL charges based on uptime, storage, and any enabled backups |

## Notes

- Cloud SQL is usually the main paid resource for this project.
- App Engine may also incur cost if deployed traffic or instance usage exceeds the free tier.
- Cloud Storage can incur small costs if SQL dump files are uploaded for import.
- Always verify current prices in the Google Cloud Billing console or pricing calculator before relying on estimates.
