require "net/http"
require "uri"
require "json"

class UrlShortenerService
  # Using is.gd API (free, no API key required, more reliable)
  def self.shorten(long_url)
    return nil if long_url.blank?
    return long_url unless valid_url?(long_url)

    short_url = shorten_with_isgd(long_url)
    return short_url if short_url.present?

    short_url = shorten_with_tinyurl(long_url)
    return short_url if short_url.present?

    # Return original URL if shortening fails
    long_url
  end

  private

  def self.shorten_with_isgd(long_url)
    begin
      uri = URI("https://is.gd/create.php")
      params = { format: "json", url: long_url }
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 5
      http.read_timeout = 5
      # Set ca_file to use system certificates if available
      http.ca_file = "/etc/ssl/cert.pem" if File.exist?("/etc/ssl/cert.pem")

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        body = response.body.to_s

        begin
          data = JSON.parse(body)
          if data["shorturl"].present?
            puts "Successfully shortened: #{long_url} -> #{data['shorturl']}" if Rails.env.development?
            return data["shorturl"]
          elsif data["errormessage"]
            Rails.logger.error("URL shortening error: #{data['errormessage']}")
          else
            Rails.logger.error("URL shortening unexpected response: #{body.first(300)}")
          end
        rescue JSON::ParserError
          Rails.logger.error("URL shortening non-JSON response: #{body.first(300)}")
        end
      else
        Rails.logger.error("URL shortening HTTP error: #{response.code} - #{response.body}")
      end
    rescue => e
      Rails.logger.error("URL shortening failed (is.gd): #{e.class} - #{e.message}")
      puts "Error shortening URL: #{e.message}" if Rails.env.development?
    end

    nil
  end

  def self.shorten_with_tinyurl(long_url)
    begin
      uri = URI("https://tinyurl.com/api-create.php")
      uri.query = URI.encode_www_form({ url: long_url })

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 5
      http.read_timeout = 5
      http.ca_file = "/etc/ssl/cert.pem" if File.exist?("/etc/ssl/cert.pem")

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        body = response.body.to_s.strip
        if valid_url?(body)
          puts "Successfully shortened with TinyURL: #{long_url} -> #{body}" if Rails.env.development?
          return body
        end

        Rails.logger.error("TinyURL unexpected response: #{body.first(300)}")
      else
        Rails.logger.error("TinyURL HTTP error: #{response.code} - #{response.body}")
      end
    rescue => e
      Rails.logger.error("URL shortening failed (TinyURL): #{e.class} - #{e.message}")
      puts "Error shortening URL via TinyURL: #{e.message}" if Rails.env.development?
    end

    nil
  end

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
