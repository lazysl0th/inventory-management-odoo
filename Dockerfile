FROM odoo:17.0

COPY ./addons /mnt/extra-addons

COPY ./odoo.conf.tpl /etc/odoo/odoo.conf.tpl

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown -R odoo:odoo /mnt/extra-addons

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]
