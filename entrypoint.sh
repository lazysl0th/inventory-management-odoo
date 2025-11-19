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

echo ">> Checking if DB is initialized..."
CHECK_DB=$(psql "host=$DATABASE_HOST port=$DATABASE_PORT user=$DATABASE_USER password=$DATABASE_PASSWORD dbname=$DATABASE_NAME" -tAc "SELECT COUNT(*) FROM pg_tables WHERE tablename='ir_module_module';" || echo "0")

if [ "$CHECK_DB" = "0" ]; then
  echo ">> Database empty — initializing Odoo base module..."
  exec su odoo -s /bin/bash -c "odoo --config=\"$OUTPUT\" -i base --load-language=en_US"
else
  echo ">> Database already initialized — starting normally."
  exec su odoo -s /bin/bash -c "odoo --config=\"$OUTPUT\""
fi
