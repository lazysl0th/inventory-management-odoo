FROM odoo:17.0

COPY odoo.conf /etc/odoo/odoo.conf

COPY ./addons /mnt/extra-addons/

USER odoo