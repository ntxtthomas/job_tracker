require "net/http"
require "uri"
require "json"

class UrlShortenerService
  # Using is.gd API (free, no API key required, more reliable)
  def self.shorten(long_url)
    return nil if long_url.blank?
    return long_url unless valid_url?(long_url)

    begin
      uri = URI("https://is.gd/create.php")
      params = { format: "json", url: long_url }
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 5
      http.read_timeout = 5

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        if data["shorturl"].present?
          puts "Successfully shortened: #{long_url} -> #{data['shorturl']}" if Rails.env.development?
          return data["shorturl"]
        elsif data["errormessage"]
          Rails.logger.error("URL shortening error: #{data['errormessage']}")
        end
      else
        Rails.logger.error("URL shortening HTTP error: #{response.code} - #{response.body}")
      end
    rescue => e
      Rails.logger.error("URL shortening failed: #{e.class} - #{e.message}")
      puts "Error shortening URL: #{e.message}" if Rails.env.development?
    end

    # Return original URL if shortening fails
    long_url
  end

  private

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
