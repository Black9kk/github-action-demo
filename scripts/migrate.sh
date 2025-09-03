#!/bin/bash
set -euo pipefail

echo "=== Running SQL migration directly in RDS ==="

PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f ./sql/migrate.sql

echo "=== Migration completed ==="
