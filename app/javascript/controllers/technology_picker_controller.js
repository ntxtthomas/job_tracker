import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "checkbox", "result" ]

  apply() {
    const pastedTechnologies = this.inputTarget.value
      .split(/[;,\n]+/)
      .map((technology) => technology.trim())
      .filter(Boolean)

    const checkboxesByName = new Map(
      this.checkboxTargets.map((checkbox) => [
        this.normalize(checkbox.dataset.technologyName),
        checkbox
      ])
    )
    const unmatched = []
    let selected = 0

    pastedTechnologies.forEach((technology) => {
      const checkbox = checkboxesByName.get(this.normalize(technology))

      if (checkbox) {
        checkbox.checked = true
        selected += 1
      } else {
        unmatched.push(technology)
      }
    })

    const messages = []
  if (selected > 0) messages.push(`${selected} ${selected === 1 ? "technology" : "technologies"} selected`)
    if (unmatched.length) messages.push(`Not found: ${unmatched.join(", ")}`)

    this.resultTarget.textContent = messages.join(". ") || "Paste one or more technologies to match the catalog."
  }

  normalize(technology) {
    return technology.toLowerCase().replace(/\s+/g, " ").trim()
  }
}