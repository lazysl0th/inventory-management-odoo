FROM odoo:17.0

RUN mkdir -p /mnt/extra-addons

COPY ./addons /mnt/extra-addons

ENV ODOO_CONF=/etc/odoo/odoo.conf
RUN echo "addons_path = /usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons" >> $ODOO_CONF
