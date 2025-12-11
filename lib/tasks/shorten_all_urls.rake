namespace :urls do
  desc "Shorten all existing website and LinkedIn URLs in companies and opportunities"
  task shorten_all: :environment do
    puts "Starting URL shortening for existing companies and opportunities..."

    # Shorten company websites
    companies_with_website = Company.where.not(website: [ nil, "" ])
                                     .where.not("website LIKE ?", "%is.gd%")

    puts "\nFound #{companies_with_website.count} companies with websites to shorten"

    companies_with_website.find_each.with_index do |company, index|
      original_url = company.website
      short_url = UrlShortenerService.shorten(original_url)

      if short_url != original_url
        company.update_column(:website, short_url)
        puts "[#{index + 1}/#{companies_with_website.count}] Company website shortened: #{original_url[0..50]}... -> #{short_url}"
      else
        puts "[#{index + 1}/#{companies_with_website.count}] Company website skipped: #{original_url[0..50]}..."
      end

      sleep(0.5)
    end

    # Shorten company LinkedIn URLs
    companies_with_linkedin = Company.where.not(linkedin: [ nil, "" ])
                                      .where.not("linkedin LIKE ?", "%is.gd%")

    puts "\nFound #{companies_with_linkedin.count} companies with LinkedIn URLs to shorten"

    companies_with_linkedin.find_each.with_index do |company, index|
      original_url = company.linkedin
      short_url = UrlShortenerService.shorten(original_url)

      if short_url != original_url
        company.update_column(:linkedin, short_url)
        puts "[#{index + 1}/#{companies_with_linkedin.count}] Company LinkedIn shortened: #{original_url[0..50]}... -> #{short_url}"
      else
        puts "[#{index + 1}/#{companies_with_linkedin.count}] Company LinkedIn skipped: #{original_url[0..50]}..."
      end

      sleep(0.5)
    end

    # Shorten opportunity websites
    opportunities_with_website = Opportunity.where.not(website: [ nil, "" ])
                                            .where.not("website LIKE ?", "%is.gd%")

    puts "\nFound #{opportunities_with_website.count} opportunities with websites to shorten"

    opportunities_with_website.find_each.with_index do |opportunity, index|
      original_url = opportunity.website
      short_url = UrlShortenerService.shorten(original_url)

      if short_url != original_url
        opportunity.update_column(:website, short_url)
        puts "[#{index + 1}/#{opportunities_with_website.count}] Opportunity website shortened: #{original_url[0..50]}... -> #{short_url}"
      else
        puts "[#{index + 1}/#{opportunities_with_website.count}] Opportunity website skipped: #{original_url[0..50]}..."
      end

      sleep(0.5)
    end

    # Shorten opportunity LinkedIn URLs
    opportunities_with_linkedin = Opportunity.where.not(linkedin: [ nil, "" ])
                                             .where.not("linkedin LIKE ?", "%is.gd%")

    puts "\nFound #{opportunities_with_linkedin.count} opportunities with LinkedIn URLs to shorten"

    opportunities_with_linkedin.find_each.with_index do |opportunity, index|
      original_url = opportunity.linkedin
      short_url = UrlShortenerService.shorten(original_url)

      if short_url != original_url
        opportunity.update_column(:linkedin, short_url)
        puts "[#{index + 1}/#{opportunities_with_linkedin.count}] Opportunity LinkedIn shortened: #{original_url[0..50]}... -> #{short_url}"
      else
        puts "[#{index + 1}/#{opportunities_with_linkedin.count}] Opportunity LinkedIn skipped: #{original_url[0..50]}..."
      end

      sleep(0.5)
    end

    puts "\nDone!"
  end
end
