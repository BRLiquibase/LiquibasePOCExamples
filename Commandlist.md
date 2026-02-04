# Liquibase Command Cheatsheet

## Basic Commands

### Connect to Database
```bash
liquibase connect
```
**What it does:** Tests your database connection using credentials from your properties file.

You can add additional commands here:
```bash
--url="jdbc:sqlserver://server:1433;database=mydb"
--username=user
--password=pass
```
**What it does:** Override properties file settings to connect to a different database on the fly.

### Update Database
```bash
liquibase update
```
**What it does:** Reads your changelog file and applies all new changesets to the database. Skips changesets already run (tracked in DATABASECHANGELOG table). This is your main deployment command.

### Rollback Last Changeset
```bash
liquibase rollback-count 1
```
**What it does:** Undoes the last changeset that was deployed. The number (1) specifies how many changesets to roll back.

### Rollback to Specific Tag
```bash
liquibase tag v1.0.0
liquibase update
liquibase rollback --tag=v1.0.0
```
**What it does:** 
- First command: Marks the current database state with a tag (like a bookmark)
- Second command: Deploys new changes
- Third command: Rolls back all changes made after the tag, returning to that bookmarked state

---

## Snapshot & Diff

### Capture Database State (Snapshot)
```bash
# Create snapshot of current database
liquibase snapshot --snapshot-format=json > snapshot.json

# Or use specific object types
liquibase snapshot --snapshot-filters=table,view --snapshot-format=json > snapshot.json
```
**What it does:** Creates a point-in-time capture of your database schema (tables, columns, indexes, etc.) and saves it to a JSON file. Think of it as taking a photo of your database structure. The second example only captures specific object types instead of everything.

### Compare Databases (Diff)
```bash
# Compare reference DB vs target DB (reference DB is set in your properties file or as commands)
liquibase diff --reference-url="jdbc:sqlserver://prod:1433;database=proddb" \
  --reference-username=user \
  --reference-password=pass
```
**What it does:** Compares two databases (or a snapshot vs a live DB) and shows you the differences. Reference DB is your "source of truth" and it compares against your target DB from the properties file. Output shows what's missing or different.

```bash
# Generate changelog from diff
liquibase diff-changelog --changelog-file=diff-changes.xml
# or
liquibase diff-changelog --changelog-file=diff-changes.postgresql.sql
```
**What it does:** Same comparison as above, but instead of just showing differences, it generates a changelog file with the changes needed to make the target match the reference. You can then run this changelog to sync the databases.

### Generate Changelog from Existing Database
```bash
liquibase generate-changelog --changelog-file=initial-schema.xml
```
**What it does:** Reverse engineers your existing database into a Liquibase changelog file. Useful when starting to use Liquibase with an existing database. Creates changesets for all current tables, views, indexes, etc.

---

## Policy Checks

### Run Policy Checks (Interactive Setup)
```bash
liquibase checks run
```
**What it does:** Analyzes your changelog against quality/governance rules (naming conventions, table limits, etc.). First run walks you through setup and creates a checks-settings file. Then scans changelog and reports violations.

*First run will guide you through configuration*

### Show Available Checks
```bash
liquibase checks show
```
**What it does:** Lists all available policy checks you can enable (TableColumnLimit, ObjectNameMustMatch, etc.) with descriptions of what each one validates.

### Enable/Disable Specific Check
```bash
liquibase checks enable --check-name=UserDefinedLabelCheck
##Follow CLI tutorial.

liquibase checks disable --check-name=UserDefinedLabelCheck
```
**What it does:** Turns specific checks on or off in your checks-settings file. CLI will prompt you to configure parameters for that check (like what the required label should be).

### Customize Check Severity
```bash
liquibase checks customize --check-name=TableColumnLimit
##Follow CLI tutorial.
```
**What it does:** Adjusts settings for a check - change severity level (0-4, where 0 is INFO and 4 is BLOCKER) or modify check parameters. CLI walks through customization options.

### Run Checks on Specific Changelog
```bash
liquibase checks run
```
**What it does:** Runs enabled checks against the changelog specified in your properties file. Returns pass/fail status and details on any violations found.

---

## Status & Validation

### Check Deployment Status
```bash
liquibase status --verbose
```
**What it does:** Shows which changesets haven't been deployed yet. Lists all pending changes waiting to run. The --verbose flag includes full changeset details and file paths.

### Validate Changelog
```bash
liquibase validate
```
**What it does:** Checks if your changelog is valid (proper XML/SQL syntax, correct file references, etc.). Doesn't touch the database - just validates the files are properly formatted.

---

## Advanced

### Run Specific Changesets
```bash
# Run only changesets with specific label
liquibase update --label-filter=v1.1

# Run only changesets with specific context
liquibase update --context-filter=dev
```
**What it does:** 
- Labels: Only deploys changesets tagged with "v1.1" label - useful for versioned releases
- Contexts: Only deploys changesets for "dev" environment - allows environment-specific changes

### SQL Generation (No Execute)
```bash
liquibase update-sql > update.sql
liquibase rollback-sql v1.0.0 > rollback.sql
```
**What it does:** Generates the SQL that *would* be executed, but doesn't actually run it. Saves output to a file for review or manual execution. Useful for getting DBA approval or understanding what will happen.

### Execute SQL File Directly
```bash
liquibase execute-sql --sql-file=update.sql
```
**What it does:** Runs a raw SQL file through Liquibase connection without needing changesets. Useful for one-off queries or unplanned hotfixes. Changes aren't tracked in DATABASECHANGELOG.

*Use the execute-sql command to directly run SQL queries without changing and applying changelog files with changesets. An example of using the execute-sql command is to check the database data or make unplanned changes when you run Liquibase in automation.*

---

## Drift Detection

### Detect Schema Drift
```bash
# Snapshot expected state
liquibase snapshot --snapshot-format=json > expected.json

##make a modification then run the below to see differences.

# Later, compare current state
liquibase diff --reference-url="offline:sqlserver?snapshot=expected.json"
```
**What it does:** 
- First command: Creates baseline snapshot of what database *should* look like
- After manual changes are made directly to the DB (outside Liquibase)
- Second command: Compares current live database against that baseline snapshot to detect unauthorized changes (drift)

The `offline:sqlserver?snapshot=` syntax tells Liquibase to use the JSON file as the reference instead of a live database.

---

## Using defaults file
### To do this create a new properties file called dev.properties.
```bash
liquibase --defaults-file=dev.properties update
```
**What it does:** Uses a different properties file instead of the default liquibase.properties. Lets you maintain separate configs for dev, test, prod environments and switch between them easily.

---

## Common Troubleshooting

### Reset DATABASECHANGELOGLOCK
```bash
liquibase release-locks
```
**What it does:** Clears stuck locks from the DATABASECHANGELOGLOCK table. Liquibase locks this table during updates to prevent concurrent deployments. If a process crashes, the lock stays set - this command clears it.

### Mark Changeset as Executed (Without Running)
```bash
liquibase changelog-sync
```
**What it does:** Marks all pending changesets as executed in DATABASECHANGELOG without actually running them. Used when changes were applied manually and you want Liquibase to think they're deployed. Dangerous - only use when you're certain the database state matches the changelog.

### Drop All Database Objects
```bash
liquibase drop-all
```
**What it does:** Deletes everything in the database - all tables, views, stored procedures, etc. Nuclear option for resetting a database to empty state.

*Use with caution - development only*