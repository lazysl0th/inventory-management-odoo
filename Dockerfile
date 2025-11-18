FROM odoo:17.0

USER root

RUN apt-get update && apt-get install -y \
    xfonts-75dpi \
    xfonts-base \
    wkhtmltopdf \
    gettext-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./addons /mnt/extra-addons
COPY ./odoo.conf.tpl /etc/odoo/odoo.conf.tpl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8069

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
