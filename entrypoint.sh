#!/bin/bash
set -e

echo ">> Generating Odoo configuration from template..."

TEMPLATE="/etc/odoo/odoo.conf.tpl"
OUTPUT="/etc/odoo/odoo.conf"

eval "echo \"$(sed 's/\"/\\"/g' $TEMPLATE)\"" > $OUTPUT

echo ">> Checking if database needs initialization..."

CHECK_DB=$(psql "host=$DATABASE_HOST port=$DATABASE_PORT user=$DATABASE_USER password=$DATABASE_PASSWORD dbname=$DATABASE_NAME" -tAc "SELECT COUNT(*) FROM pg_tables WHERE tablename = 'ir_module_module';" || echo "0")

if [ "$CHECK_DB" = "0" ]; then
  echo ">> Database is empty. Initializing base module..."
  exec odoo --config="$OUTPUT" -i base --load-language=en_US
else
  echo ">> Database already initialized. Running Odoo normally..."
  exec odoo --config="$OUTPUT"
fi
