import { Controller } from "@hotwired/stimulus"

// This controller is for ensuring only digits and dashes are entered into a phone number field
export default class extends Controller {
  static targets = ["field"]

  connect() {
    this.fieldTarget.addEventListener('input', this.ensureDigitsAndDashes)
  }

  disconnect() {
    this.fieldTarget.removeEventListener('input', this.ensureDigitsAndDashes)
  }

  ensureDigitsAndDashes(event) {
    event.target.value = event.target.value.replace(/[^0-9-]/g, '')
  }
}
