FROM odoo:17.0

COPY ./addons /mnt/extra-addons

COPY ./odoo.conf.tpl /etc/odoo/odoo.conf.tpl

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8069

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]