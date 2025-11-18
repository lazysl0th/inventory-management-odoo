from odoo import models, fields


class InventoryTextStat(models.Model):
    _name = "inventory.text.stat"
    _description = "Text statistics per field"

    inventory_id = fields.Many2one(
        "inventory",
        string="Inventory",
        ondelete="cascade",
        readonly=True,
    )

    field_title = fields.Char(string="Field", readonly=True)
    distinct_count = fields.Integer(string="Distinct count", readonly=True)

    top_value_ids = fields.One2many(
        "inventory.text.topvalue",
        "stat_id",
        string="Top values",
        readonly=True,
    )
