namespace :opportunities do
  desc "Shorten all existing listing URLs"
  task shorten_urls: :environment do
    puts "Starting URL shortening for existing opportunities..."

    opportunities = Opportunity.where.not(listing_url: [ nil, "" ])
                                .where.not("listing_url LIKE ?", "%is.gd%")

    total = opportunities.count
    puts "Found #{total} opportunities with URLs to shorten"

    opportunities.find_each.with_index do |opportunity, index|
      original_url = opportunity.listing_url
      short_url = UrlShortenerService.shorten(original_url)

      if short_url != original_url
        opportunity.update_column(:listing_url, short_url)
        puts "[#{index + 1}/#{total}] Shortened: #{original_url[0..50]}... -> #{short_url}"
      else
        puts "[#{index + 1}/#{total}] Skipped: #{original_url[0..50]}..."
      end

      # Be nice to the API - add a small delay
      sleep(0.5)
    end

    puts "Done!"
  end
end
