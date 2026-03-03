import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["company", "opportunity", "contact"]
  static values = {
    opportunities: Array,
    contacts: Array
  }

  connect() {
    if (!this.hasCompanyTarget || !this.hasOpportunityTarget || !this.hasContactTarget) {
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

    this.refreshDependentOptions()
  }

  companyChanged() {
    this.refreshDependentOptions({ clearOpportunityIfInvalid: true, clearContactIfInvalid: true })
  }

  opportunityChanged() {
    const selectedOpportunity = this.opportunitiesValue.find(
      (opportunity) => String(opportunity.id) === this.opportunityTarget.value
    )

    if (selectedOpportunity) {
      this.companyTarget.value = String(selectedOpportunity.company_id)
    }

    this.refreshContactOptions({ clearIfInvalid: true })
  }

  refreshDependentOptions({ clearOpportunityIfInvalid = false, clearContactIfInvalid = false } = {}) {
    this.refreshOpportunityOptions({ clearIfInvalid: clearOpportunityIfInvalid })
    this.refreshContactOptions({ clearIfInvalid: clearContactIfInvalid })
  }

  refreshOpportunityOptions({ clearIfInvalid = false } = {}) {
    const companyId = this.companyTarget.value
    const currentValue = this.opportunityTarget.value

    const scopedOpportunities = companyId
      ? this.opportunitiesValue.filter((opportunity) => String(opportunity.company_id) === companyId)
      : this.opportunitiesValue

    this.rebuildOptions(this.opportunityTarget, scopedOpportunities, "Select an opportunity", currentValue)

    const stillValid = scopedOpportunities.some((opportunity) => String(opportunity.id) === currentValue)
    if (clearIfInvalid && currentValue && !stillValid) {
      this.opportunityTarget.value = ""
    }
  }

  refreshContactOptions({ clearIfInvalid = false } = {}) {
    const companyId = this.companyTarget.value
    const currentValue = this.contactTarget.value

    const scopedContacts = companyId
      ? this.contactsValue.filter((contact) => String(contact.company_id) === companyId)
      : this.contactsValue

    this.rebuildOptions(this.contactTarget, scopedContacts, "Optional contact", currentValue)

    const stillValid = scopedContacts.some((contact) => String(contact.id) === currentValue)
    if (clearIfInvalid && currentValue && !stillValid) {
      this.contactTarget.value = ""
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
