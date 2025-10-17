// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// Make table rows clickable - works with Turbo navigation
function initializeClickableRows() {
  const clickableRows = document.querySelectorAll(".clickable-row");

  clickableRows.forEach((row) => {
    // Check if already initialized to avoid duplicate listeners
    if (!row.hasAttribute("data-clickable-initialized")) {
      row.addEventListener("click", function () {
        const href = this.dataset.href;
        if (href) {
          window.location.href = href;
        }
      });

      // Add cursor pointer to indicate clickability
      row.style.cursor = "pointer";
      row.setAttribute("data-clickable-initialized", "true");
    }
  });
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", initializeClickableRows);

// Initialize after Turbo navigates to a new page
document.addEventListener("turbo:load", initializeClickableRows);
