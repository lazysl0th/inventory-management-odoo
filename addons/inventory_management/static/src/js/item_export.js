/** @odoo-module **/

import { registry } from "@web/core/registry";
import { patch } from "@web/core/utils/patch";

patch(registry.category("services").get("orm"), {
    async call(model, method, args, kwargs) {
        const result = await this._super(model, method, args, kwargs);

        if (method === "action_export_to_app") {
            const btn = document.querySelector(".oe_export_btn");
            if (btn) {
                btn.setAttribute("disabled", "disabled");
                btn.classList.add("btn-secondary");
                btn.classList.remove("btn-primary");
                btn.classList.remove("oe_highlight");
            }
        }

        return result;
    }
});
