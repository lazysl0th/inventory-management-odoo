#!/bin/bash
set -e

echo ">> Generating Odoo configuration from template..."

CONFIG_FILE=/etc/odoo/odoo.conf

# Replace environment variables manually using sed
sed \
  -e "s|\${DATABASE_HOST}|${DATABASE_HOST}|g" \
  -e "s|\${DATABASE_PORT}|${DATABASE_PORT}|g" \
  -e "s|\${DATABASE_USER}|${DATABASE_USER}|g" \
  -e "s|\${DATABASE_PASSWORD}|${DATABASE_PASSWORD}|g" \
  -e "s|\${DATABASE_NAME}|${DATABASE_NAME}|g" \
  /etc/odoo/odoo.conf.tpl > $CONFIG_FILE

echo ">> Starting Odoo..."
exec odoo --config=$CONFIG_FILE
