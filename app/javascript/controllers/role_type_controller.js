import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="role-type"
export default class extends Controller {
  static targets = ["roleSelect", "fieldsContainer"]

  connect() {
    console.log("Role type controller connected")
  }

  toggle(event) {
    const roleType = event.target.value
    console.log("Role type changed to:", roleType)
    
    // For now, just a placeholder
    // Full implementation would require adding data-role-type attributes
    // to sections and showing/hiding them based on selection
  }
}
