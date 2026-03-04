import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["company", "opportunity"]
  static values = {
    opportunities: Array
  }

  connect() {
    if (!this.hasCompanyTarget || !this.hasOpportunityTarget) {
      return
    }

    if (!this.companyTarget.value && this.opportunityTarget.value) {
      const selectedOpportunity = this.opportunitiesValue.find(
        (opportunity) => String(opportunity.id) === this.opportunityTarget.value
      )

      if (selectedOpportunity) {
        this.companyTarget.value = String(selectedOpportunity.company_id)
      }
    }

    this.refreshOpportunityOptions()
  }

  companyChanged() {
    this.refreshOpportunityOptions({ clearIfInvalid: true })
  }

  refreshOpportunityOptions({ clearIfInvalid = false } = {}) {
    const companyId = this.companyTarget.value
    const currentValue = this.opportunityTarget.value

    const scopedOpportunities = companyId
      ? this.opportunitiesValue.filter((opportunity) => String(opportunity.company_id) === companyId)
      : this.opportunitiesValue

    this.rebuildOptions(this.opportunityTarget, scopedOpportunities, "Optional opportunity", currentValue)

    const stillValid = scopedOpportunities.some((opportunity) => String(opportunity.id) === currentValue)
    if (clearIfInvalid && currentValue && !stillValid) {
      this.opportunityTarget.value = ""
    }
  }

  rebuildOptions(selectElement, records, promptText, selectedValue) {
    selectElement.innerHTML = ""

    const promptOption = document.createElement("option")
    promptOption.value = ""
    promptOption.textContent = promptText
    selectElement.appendChild(promptOption)

    records.forEach((record) => {
      const option = document.createElement("option")
      option.value = String(record.id)
      option.textContent = record.label
      if (String(record.id) === String(selectedValue)) {
        option.selected = true
      }
      selectElement.appendChild(option)
    })
  }
}
