FROM odoo:17

RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    xfonts-75dpi \
    xfonts-base \
    gettext-base \
    && apt-get clean

COPY ./addons /mnt/extra-addons

COPY ./odoo.conf.tpl /etc/odoo/odoo.conf.tpl

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown -R odoo:odoo /mnt/extra-addons

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]
