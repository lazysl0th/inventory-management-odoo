[options]

db_host = ${DATABASE_HOST}
db_port = 5432
db_user = ${DATABASE_USER}
db_password = ${DATABASE_PASSWORD}
admin_passwd = ${MASTER_PASSWORD}
list_db = True

addons_path = /usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons

data_dir = /var/lib/odoo
proxy_mode = True
xmlrpc_port = 8069
longpolling_port = 8072
