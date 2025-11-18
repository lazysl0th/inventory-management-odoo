{
    'name': 'Inventory Management',
    'summary': 'Import inventory fields and stats from external system by API token',
    'version': '1.0',
    'category': 'Tools',
    'depends': ['base', 'web'],

    'data': [
        'security/ir.model.access.csv',
        'views/menu_action_views.xml',
        'views/inventory_views.xml',
        'views/inventory_field_views.xml',
        'views/numeric_stat_views.xml',
        'views/text_stat_views.xml',
        #'views/item_action.xml',
        #'views/item_views.xml',
    ],

    "assets": {
        "web.assets_backend": [
            "inventory_management/static/src/js/inventory_dynamic_fields.js",
            "inventory_management/static/src/js/item_export.js",
            "inventory_management/static/src/css/inventory_dynamic_fields.scss",
        ],
    },

    'installable': True,
    'application': True,
    'license': 'LGPL-3',
}
