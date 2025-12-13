class Opportunity < ApplicationRecord
  belongs_to :company

  # Delegate website and linkedin to the company
  delegate :website, :linkedin, to: :company, allow_nil: true

  before_save :shorten_urls
  before_save :standardize_salary_range

  private

  def shorten_urls
    if listing_url_changed? && listing_url.present? && !listing_url.include?("is.gd")
      self.listing_url = UrlShortenerService.shorten(listing_url)
    end
  rescue StandardError => e
    Rails.logger.error("URL shortening failed in Opportunity#shorten_urls: #{e.message}")
    # Continue with save even if shortening fails
  end

  def standardize_salary_range
    return if salary_range.blank?

    # Remove leading/trailing whitespace
    normalized = salary_range.strip

    # Convert various dash/hyphen characters to standard hyphen
    normalized = normalized.gsub(/[–—−]/, "-")

    # Remove /yr, /Yr, /year suffixes first (before number processing)
    normalized = normalized.gsub(/\s*\/\s*(yr|Yr|year)\.?/i, "")

    # Special case: if one number has K and the range doesn't, assume both are in K
    # e.g., "$110-$125k" should become "$110k-$125k"
    if normalized.match(/\$(\d+)-\$(\d+)([kK])/)
      normalized = normalized.gsub(/\$(\d+)-\$(\d+)([kK])/, '$\1k-$\2k')
    end

    # Convert K notation to full numbers
    # Handle patterns like: $110k, $117k-$145k, $147K
    normalized = normalized.gsub(/\$(\d+)([kK])/) do
      "$#{$1.to_i * 1000}"
    end

    # Also handle numbers without $ that have K
    normalized = normalized.gsub(/(\d+)([kK])/) do
      "#{$1.to_i * 1000}"
    end

    # Remove commas from numbers
    normalized = normalized.gsub(/(\d),(\d)/, '\1\2')

    # Standardize separators: convert " - ", "–", "—" to single "-"
    normalized = normalized.gsub(/\s*[-–—]+\s*/, "-")

    # Remove trailing periods and extra spaces
    normalized = normalized.gsub(/\.\s*$/, "").strip

    # Final cleanup: ensure we have proper format
    self.salary_range = normalized
  rescue StandardError => e
    Rails.logger.error("Salary standardization failed: #{e.message}")
    # Keep original value if standardization fails
  end
end
