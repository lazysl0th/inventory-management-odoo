#!/bin/bash
set -e

echo "Generating /etc/odoo/odoo.conf from template..."
envsubst < /etc/odoo/odoo.conf.tpl > /etc/odoo/odoo.conf

echo "Starting Odoo..."
exec odoo --config=/etc/odoo/odoo.conf
