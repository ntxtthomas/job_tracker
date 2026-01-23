import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="role-type"
export default class extends Controller {
  static targets = ["select", "section"]

  connect() {
    console.log("Role type controller connected")
    // Show the appropriate section on initial load
    this.toggle()
  }

  toggle(event) {
    const selectedRole = this.selectTarget.value || "software_engineer"
    console.log("Role type changed to:", selectedRole)
    
    // Hide all sections
    this.sectionTargets.forEach(section => {
      section.style.display = "none"
    })
    
    // Show the selected role's section
    const targetSection = this.sectionTargets.find(section => 
      section.dataset.role === selectedRole
    )
    
    if (targetSection) {
      targetSection.style.display = "block"
    }
  }
}
