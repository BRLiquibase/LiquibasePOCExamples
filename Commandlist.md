# Liquibase Command Cheatsheet

## Basic Commands

### Connect to Database
```bash
liquibase connect 
```
You can add additional commands here: --url="jdbc:sqlserver://server:1433;database=mydb" --username=user --password=pass

### Update Database
```bash
liquibase update
```

### Rollback Last Changeset
```bash
liquibase rollback-count 1
```

### Rollback to Specific Tag
```bash
liquibase tag v1.0.0

liquibase update

liquibase rollback --tag=v1.0.0
```

## Snapshot & Diff

### Capture Database State (Snapshot)
```bash
# Create snapshot of current database
liquibase snapshot --snapshot-format=json > snapshot.json

# Or use specific object types
liquibase snapshot --snapshot-filters=table,view
/ --snapshot-format=json > snapshot.json

```

### Compare Databases (Diff)
```bash
# Compare reference DB vs target DB (reference DB is set in your properties file or as commands)
liquibase diff 

--reference-url="jdbc:sqlserver://prod:1433;database=proddb" --reference-username=user --reference-password=pass

# Generate changelog from diff
liquibase diff-changelog --changelog-file=diff-changes.xml

or
liquibase diff-changelog --changelog-file=diff-changes.postgresql.sql

```

### Generate Changelog from Existing Database
```bash
liquibase generate-changelog --changelog-file=initial-schema.xml
```

## Policy Checks

### Run Policy Checks (Interactive Setup)
```bash
liquibase checks run
```
*First run will guide you through configuration*

### Show Available Checks
```bash
liquibase checks show
```

### Enable/Disable Specific Check
```bash
liquibase checks enable --check-name=UserDefinedLabelCheck
##Follow CLI tutorial.

liquibase checks disable --check-name=UserDefinedLabelCheck
```

### Customize Check Severity
```bash
liquibase checks customize --check-name=TableColumnLimit
##Follow CLI tutorial.

```

### Run Checks on Specific Changelog
```bash
liquibase checks run
```

## Status & Validation

### Check Deployment Status
```bash
liquibase status --verbose
```

### Validate Changelog
```bash
liquibase validate
```


## Advanced

### Run Specific Changesets
```bash
# Run only changesets with specific label
liquibase update --label-filter=v1.1

# Run only changesets with specific context
liquibase update --context-filter=dev
```

### SQL Generation (No Execute)
```bash
liquibase update-sql > update.sql
liquibase rollback-sql v1.0.0 > rollback.sql
```

### Execute SQL File Directly
```bash
liquibase execute-sql --sql-file=update.sql
## Use the execute-sql command to directly run SQL queries without changing and applying changelog files with changesets. An example of using the execute-sql command is to check the database data or make unplanned changes when you run Liquibase in automation.
```

## Drift Detection

### Detect Schema Drift
```bash
# Snapshot expected state
liquibase snapshot --snapshot-format=json > expected.json

##make a modification then run the below to see differences.

# Later, compare current state
liquibase diff --reference-url="offline:sqlserver?snapshot=expected.json"
```


### Using defaults file
### To do this create a new properties file called dev.properties.
```bash
liquibase --defaults-file=dev.properties update
```

## Common Troubleshooting

### Reset DATABASECHANGELOGLOCK
```bash
liquibase release-locks
```

### Mark Changeset as Executed (Without Running)
```bash
liquibase changelog-sync
```

### Drop All Database Objects
```bash
liquibase drop-all
```
*Use with caution - development only*
