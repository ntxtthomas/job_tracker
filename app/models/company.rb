class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :interactions, dependent: :destroy
  has_many :opportunities, dependent: :destroy
  
  before_save :shorten_urls
  
  private
  
  def shorten_urls
    if website_changed? && website.present? && !website.include?('is.gd')
      shortened = UrlShortenerService.shorten(website)
      self.website = shortened if shortened.present?
    end
    
    if linkedin_changed? && linkedin.present? && !linkedin.include?('is.gd')
      shortened = UrlShortenerService.shorten(linkedin)
      self.linkedin = shortened if shortened.present?
    end
  end
end
