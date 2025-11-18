from odoo import models, fields


class InventoryTextTopValue(models.Model):
    _name = "inventory.text.topvalue"
    _description = "Top text values"

    stat_id = fields.Many2one(
        "inventory.text.stat",
        string="Stat",
        ondelete="cascade",
        readonly=True,
    )

    value = fields.Char(string="Value", readonly=True)
    count = fields.Integer(string="Count", readonly=True)
