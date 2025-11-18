from odoo import models, fields

class InventoryNumericStat(models.Model):
    _name = "inventory.numeric.stat"
    _description = "Numeric statistics per field"

    inventory_id = fields.Many2one(
        "inventory",
        string="Inventory",
        ondelete="cascade",
        readonly=True,
    )

    field_title = fields.Char(string="Field", readonly=True)
    min_value = fields.Float(string="Min", readonly=True)
    max_value = fields.Float(string="Max", readonly=True)
    avg_value = fields.Float(string="Average", readonly=True)
