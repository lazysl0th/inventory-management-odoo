from odoo import models, fields, api, _
from odoo.exceptions import UserError
import requests


class Inventory(models.Model):
    _name = "inventory"
    _rec_name = "title"
    _description = "Inventory"

    title = fields.Char(string="Title", readonly=True)
    api_token = fields.Char(string="API Token", required=True)
    items_count = fields.Integer(string="Items count", readonly=True)

    item_ids = fields.One2many(
        'inventory.item',
        'inventory_id',
        string='Items',
    )

    field_ids = fields.One2many(
        "inventory.field",
        "inventory_id",
        string="Fields",
        readonly=True,
    )

    numeric_stat_ids = fields.One2many(
        "inventory.numeric.stat",
        "inventory_id",
        string="Numeric Stats",
        readonly=True,
    )

    text_stat_ids = fields.One2many(
        "inventory.text.stat",
        "inventory_id",
        string="Text Stats",
        readonly=True,
    )

    def name_get(self):
        result = []
        for rec in self:
            name = rec.title or f"INV {rec.id}"
            result.append((rec.id, name))
        return result

    @api.constrains('api_token')
    def _check_unique_token(self):
        for rec in self:
            if not rec.api_token:
                continue

            exists = self.search([
                ('api_token', '=', rec.api_token),
                ('id', '!=', rec.id)
            ], limit=1)

            if exists:
                raise UserError(_(
                    "Inventory with this API token already exists:\n"
                    "Title: %s (ID %s)\n\n"
                    "You cannot create another inventory with the same token."
                ) % (exists.title, exists.id))

    def action_import_from_api(self):
        base_url = (
            self.env["ir.config_parameter"]
            .sudo()
            .get_param("inventory.api_base_url")
        )
        if not base_url:
            raise UserError(_("Set 'inventory.api_base_url' in System Parameters."))
        for inventory in self:
            if not inventory.id or isinstance(inventory.id, models.NewId):
                raise UserError(_(
                    "You must save the Inventory before importing.\n"
                    "Click 'Save' first."
                ))
            url = f"{base_url}/inventories/{inventory.api_token}"
            try:
                resp = requests.get(url, timeout=15)
            except Exception as e:
                raise UserError(_("Request error: %s") % e)
            if resp.status_code != 200:
                raise UserError(_("API error %s: %s") % (resp.status_code, resp.text))
            data = resp.json()
            inventory._update_from_payload(data)

        return True

    def _update_from_payload(self, data):
        inventory_info = data.get("inventory") or {}

        self.write({
            "title": inventory_info.get("title"),
            "items_count": inventory_info.get("itemsCount"),
        })
        self.field_ids.unlink()
        new_fields = [
            (0, 0, {
                "title": f.get("title"),
                "type": f.get("type"),
                "external_id": f.get("id"),
            })
            for f in inventory_info.get("fields", [])
        ]
        stats_data = data.get("stats") or {}
        num_stats = stats_data.get("numStats", [])
        text_stats = stats_data.get("textStats", [])

        self.numeric_stat_ids.unlink()
        self.text_stat_ids.unlink()

        numeric_vals = [
            (0, 0, {
                "field_title": s.get("field"),
                "min_value": s.get("min"),
                "max_value": s.get("max"),
                "avg_value": s.get("average"),
            })
            for s in num_stats
        ]

        text_vals = []
        for s in text_stats:
            top_values = [
                (0, 0, {
                    "value": tv.get("value"),
                    "count": tv.get("count"),
                })
                for tv in s.get("topValues", [])
            ]

            text_vals.append((0, 0, {
                "field_title": s.get("field"),
                "distinct_count": len(s.get("topValues", [])),
                "top_value_ids": top_values,
            }))

        self.write({
            "field_ids": new_fields,
            "numeric_stat_ids": numeric_vals,
            "text_stat_ids": text_vals,
        })

    def get_inventory_fields(self):
        self.ensure_one()
        return [
            {
                "id": f.external_id or f.id,
                "title": f.title,
                "type": f.type,
            }
            for f in self.field_ids
        ]
