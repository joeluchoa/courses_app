import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="list-filter"
export default class extends Controller {
    static targets = ["input", "item"]

    filter() {
        const query = this.inputTarget.value.toLowerCase()

        this.itemTargets.forEach(item => {
            const searchValue = item.dataset.searchValue.toLowerCase()
            if (searchValue.includes(query)) {
                item.classList.remove("d-none")
            } else {
                item.classList.add("d-none")
            }
        })
    }
}
