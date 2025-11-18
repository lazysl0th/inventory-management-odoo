FROM odoo:17

RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    xfonts-75dpi \
    xfonts-base \
    && apt-get clean

COPY ./addons /mnt/extra-addons

COPY ./odoo.conf /etc/odoo/odoo.conf

RUN chown -R odoo:odoo /mnt/extra-addons

EXPOSE 8069

CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
