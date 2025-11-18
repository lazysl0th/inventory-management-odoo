/** @odoo-module **/

import { Component, useState, xml } from "@odoo/owl";
import { registry } from "@web/core/registry";
import { standardFieldProps } from "@web/views/fields/standard_field_props";

class InventoryDynamicFields extends Component {
    static props = {
        ...standardFieldProps,
    };

    static template = xml`
        <div class="o_dynamic_inventory_fields" style="width:100%;">
            <t t-if="state.fields.length">
                <t t-foreach="state.fields" t-as="field" t-key="field.id">
                    <div class="o_form_group mb-3" style="width:100%;">
                        <label class="fw-bold d-block mb-1">
                            <t t-esc="field.title" />
                        </label>

                        <!-- TEXT -->
                        <t t-if="field.type === 'TEXT'">
                            <input
                                type="text"
                                class="form-control"
                                t-att-value="getValue(field.id)"
                                t-att-data-field-id="field.id"
                                t-on-input="onInput"
                            />
                        </t>

                        <!-- LONGTEXT -->
                        <t t-elif="field.type === 'LONGTEXT'">
                            <textarea
                                class="form-control"
                                rows="3"
                                t-att-value="getValue(field.id)"
                                t-att-data-field-id="field.id"
                                t-on-input="onInput"
                            ></textarea>
                        </t>

                        <!-- NUMBER -->
                        <t t-elif="field.type === 'NUMBER'">
                            <input
                                type="number"
                                class="form-control"
                                t-att-value="getValue(field.id)"
                                t-att-data-field-id="field.id"
                                t-on-input="onInput"
                            />
                        </t>

                        <!-- BOOLEAN -->
                        <t t-elif="field.type === 'BOOLEAN'">
                            <input
                                type="checkbox"
                                class="form-check-input"
                                t-att-data-field-id="field.id"
                                t-att-checked="getValue(field.id) ? true : false"
                                t-on-change="onCheckbox"
                            />
                        </t>

                        <!-- FALLBACK -->
                        <t t-else="">
                            <input
                                type="text"
                                class="form-control"
                                t-att-value="getValue(field.id)"
                                t-att-data-field-id="field.id"
                                t-on-input="onInput"
                            />
                        </t>

                    </div>
                </t>
            </t>
            <t t-else="">
                <span class="text-muted">No dynamic fields for this inventory</span>
            </t>
        </div>
    `;

    setup() {
        this.state = useState({ fields: [] });
        this.onInput = this.onInput.bind(this);
        this.onCheckbox = this.onCheckbox.bind(this);

        this.loadFields();
    }

    async loadFields() {
        const record = this.props.record.data;
        let inv = record.inventory_id;

        if (!inv) {
            this.state.fields = [];
            return;
        }

        if (Array.isArray(inv)) {
            if (typeof inv[0] !== "number") {
                this.state.fields = [];
                return;
            }
            inv = inv[0];
        }

        const result = await this.env.services.rpc(
            "/inventory_management/get_fields",
            { inventory_id: inv }
        );

        this.state.fields = result || [];
    }

    getValue(fieldId) {
        const data = this.props.record.data.data || {};
        return data[String(fieldId)] ?? "";
    }

    onInput(ev) {
        const fieldId = ev.target.dataset.fieldId;
        const value = ev.target.value;

        const data = {
            ...(this.props.record.data.data || {}),
            [fieldId]: value,
        };

        this.props.record.update({ data });
    }

    onCheckbox(ev) {
        const fieldId = ev.target.dataset.fieldId;
        const value = ev.target.checked;

        const data = {
            ...(this.props.record.data.data || {}),
            [fieldId]: value,
        };

        this.props.record.update({ data });
    }
}

export const inventoryDynamicFieldsField = {
    component: InventoryDynamicFields,
    supportedTypes: ["json"],
    extractProps({ record, name, value, update }) {
        return { record, name, value, update };
    },
};

registry.category("fields").add(
    "inventory_dynamic_fields",
    inventoryDynamicFieldsField
);
