#!/bin/bash
set -e

echo ">> Generating Odoo configuration from template..."

TEMPLATE="/etc/odoo/odoo.conf.tpl"
OUTPUT="/etc/odoo/odoo.conf"

eval "echo \"$(sed 's/\"/\\"/g' $TEMPLATE)\"" > $OUTPUT

echo ">> Waiting for PostgreSQL..."

until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER"; do
  echo "Database not ready yet..."
  sleep 1
done

echo ">> Starting Odoo..."
exec odoo --config="$OUTPUT"