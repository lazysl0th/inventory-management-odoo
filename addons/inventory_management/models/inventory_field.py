from odoo import models, fields

class InventoryField(models.Model):
    _name = "inventory.field"
    _description = "Inventory Field"

    title = fields.Char(required=True, readonly=True)
    type = fields.Char(string="Type", readonly=True)
    external_id = fields.Integer(readonly=True)

    inventory_id = fields.Many2one(
        "inventory",
        string="Inventory",
        ondelete="cascade",
        readonly=True,
    )
