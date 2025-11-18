FROM odoo:17

# Install deps needed by wkhtmltopdf
RUN apt-get update && apt-get install -y \
    xfonts-75dpi \
    xfonts-base \
    fontconfig \
    libxrender1 \
    libxext6 \
    libssl3 \
    curl \
    gettext-base \
    && apt-get clean

RUN curl -L -o wkhtml.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bookworm_amd64.deb \
    && apt-get update \
    && apt-get install -y ./wkhtml.deb \
    && rm wkhtml.deb

COPY ./addons /mnt/extra-addons

COPY ./odoo.conf.tpl /etc/odoo/odoo.conf.tpl

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown -R odoo:odoo /mnt/extra-addons

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]
