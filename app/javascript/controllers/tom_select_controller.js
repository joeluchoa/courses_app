import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="tom-select"
export default class extends Controller {
    connect() {
        this.select = new TomSelect(this.element, {
            plugins: ['remove_button'],
            allowEmptyOption: true,
            maxOptions: null,
            onDropdownOpen: () => {
                // Fix for Bootstrap modal/card z-index if needed
            }
        })
    }

    disconnect() {
        if (this.select) {
            this.select.destroy()
        }
    }
}
