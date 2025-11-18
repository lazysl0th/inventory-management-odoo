from odoo import models, fields, api, _
from odoo.exceptions import UserError
import requests


class Item(models.Model):
    _name = 'inventory.item'
    _description = 'Item'
    _order = 'id desc'

    inventory_id = fields.Many2one(
        'inventory',
        string='Inventory',
        ondelete='cascade',
    )

    data = fields.Json('Data', default=dict)
    owner_email = fields.Char(string="Owner (email)", required=True)

    external_id = fields.Char(string='External ID', readonly=True)
    exported = fields.Boolean(string='Exported', readonly=True)

    def _build_export_payload(self, item):
        item_data = item.data or {}

        payload = []

        for field_id, value in item_data.items():
            payload.append({
                "fieldId": int(field_id),
                "value": value
            })

        return payload


    def action_export_to_app(self):
        for item in self:
            if item.exported:
                raise UserError(_("This item is already exported."))
            api_token = item.env.context.get("api_token")
            if not api_token and item.inventory_id:
                api_token = item.inventory_id.api_token

            if not api_token:
                raise UserError(_("Inventory has no API token."))
            base_url = item.env['ir.config_parameter'].sudo().get_param(
                'inventory.api_base_url'
            )
            if not base_url:
                raise UserError(_("API base URL not configured."))

            values = item._build_export_payload(item)

            payload = {
                "values": values,
                "owner": item.owner_email
            }

            url = f"{base_url}/inventories/{api_token}/item"
            headers = {
                "Authorization": f"Bearer {api_token}",
                "Content-Type": "application/json",
            }

            try:
                response = requests.post(url, json=payload, headers=headers)
            except Exception as e:
                raise UserError(_("Connection error: %s") % str(e))

            if response.status_code not in (200, 201):
                raise UserError(_("Error exporting item: %s") % response.text)

            result = response.json()

            item.external_id = result.get("id")
            item.exported = True

        return True
