class Opportunity < ApplicationRecord
  belongs_to :company
  
  # Delegate website and linkedin to the company
  delegate :website, :linkedin, to: :company, allow_nil: true
  
  before_save :shorten_urls
  
  private
  
  def shorten_urls
    if listing_url_changed? && listing_url.present? && !listing_url.include?('is.gd')
      self.listing_url = UrlShortenerService.shorten(listing_url)
    end
  end
end
