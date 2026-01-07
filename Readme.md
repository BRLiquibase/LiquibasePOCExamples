# Liquibase PostgreSQL Starter

Simple Liquibase setup for PostgreSQL deployments.

## Quick Start

1. Clone this repository
2. Update `liquibase.properties` with your database connection
3. Run: `liquibase flow`

## Structure

- `liquibase.properties` - Database connection settings
- `changelog/changelog-root.xml` - Main changelog (auto-includes all SQL files)
- `changelog/v1.x/` - Versioned SQL changesets
- `liquibase.flowfile.yaml` - Workflow definitions
- `liquibase.flowfile.rollback.yaml` - Workflow definition for rollbacks
- `Jenkinsfile` - CI/CD pipeline

## Local Commands
```bash
# Check what will be deployed
liquibase status

# Deploy all changes
liquibase update

# Rollback last change
liquibase rollback-count 1

# Preview SQL without executing
liquibase update-sql

# Using flow file
liquibase flow --flow-file=liquibase.flowfile.yaml validate
liquibase flow --flow-file=liquibase.flowfile.yaml deploy
```

## Jenkins Setup

Some variables you might need. Configure these credentials in Jenkins:
- `postgres-url` - Example: `jdbc:postgresql://db-server:5432/mydb`
- `postgres-user` - Database username
- `postgres-pass` - Database password
- `liquibase-license` - Your Liquibase Pro/Secure license key

## Adding New Changes

1. Create new SQL file in appropriate version folder (e.g., `changelog/v1.2/004-new-change.sql`)
2. Use naming convention: `###-description.sql` (ensures correct execution order)
3. Include rollback statements
4. Commit and push - Jenkins will automatically deploy

## SQL File Format
```sql
--liquibase formatted sql

--changeset yourname:uniqueID labels:v1.0 context:prod
--comment: Description of what this change does
-- Your SQL here
--rollback -- Your rollback SQL here
```
