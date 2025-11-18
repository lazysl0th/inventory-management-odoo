from odoo import http
from odoo.http import request

class InventoryController(http.Controller):

    @http.route('/inventory_management/get_fields', type='json', auth='user')
    def get_fields(self, inventory_id):
        # если пришёл массив [id, display_name]
        if isinstance(inventory_id, list):
            inventory_id = inventory_id[0]

        inv = request.env['inventory'].browse(int(inventory_id))
        inv.ensure_one()
        return inv.get_inventory_fields()
