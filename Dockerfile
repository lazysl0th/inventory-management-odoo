FROM odoo:17.0

COPY ./addons /mnt/extra-addons

COPY ./odoo.conf.tpl /etc/odoo/odoo.conf.tpl

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chown -R odoo:odoo /mnt/extra-addons

EXPOSE 8069

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]