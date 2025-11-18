#!/bin/bash
set -e

echo ">> Generating Odoo configuration from template..."

TEMPLATE="/etc/odoo/odoo.conf.tpl"
OUTPUT="/etc/odoo/odoo.conf"

eval "echo \"$(sed 's/\"/\\"/g' $TEMPLATE)\"" > $OUTPUT

echo ">> Fixing permissions for Railway volume..."
mkdir -p /var/lib/odoo/sessions
mkdir -p /var/lib/odoo/filestore
chown -R odoo:odoo /var/lib/odoo
chown -R odoo:odoo /mnt/extra-addons

echo ">> Waiting for PostgreSQL..."
until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER"; do
  echo "Database not ready yet..."
  sleep 1
done

echo ">> Starting Odoo..."
exec su odoo -s /bin/bash -c "odoo --config=\"$OUTPUT\""
