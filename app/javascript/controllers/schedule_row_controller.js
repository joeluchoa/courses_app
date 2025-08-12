import { Controller } from "@hotwired/stimulus"

// Connects to each <tr> in the schedule table
export default class extends Controller {
  static targets = ["checkbox", "startTime", "endTime"]

  // This method runs automatically when the controller connects to the element.
  connect() {
    this.toggle()
  }

  // This method is called whenever the checkbox value changes.
  toggle() {
    const isChecked = this.checkboxTarget.checked

    // Enable or disable the time fields based on the checkbox state.
    this.startTimeTarget.disabled = !isChecked
    this.endTimeTarget.disabled = !isChecked

    // Add or remove the 'required' attribute
    this.startTimeTarget.required = isChecked
    this.endTimeTarget.required = isChecked

    // If the checkbox is unchecked, clear the values from the time fields.
    if (!isChecked) {
      this.startTimeTarget.value = ""
      this.endTimeTarget.value = ""
    }
  }
}
