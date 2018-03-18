module Api::V1::GetTimetableHelper
  require 'net/http'

  def request_term
    date = Time.now
    params = { dt: date.year }
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_term

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end
end
