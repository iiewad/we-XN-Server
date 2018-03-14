module Api::V1::GetEnergyHelper
  require 'net/http'

  def getEnergyQuery(energyParams)
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_post_endpoint +
              Settings.hunauapi.get_energy_query

    puts uri_str
    sign_str = "userId=#{energyParams['userId']}Room=#{energyParams['Room']}Time=#{energyParams['Time']}#{ENV['HUNAU_API_PARAMS_AK']}"
    sign = Digest::MD5.hexdigest sign_str

    params = { userId: energyParams['userId'],
               Room: energyParams['Room'],
               Time: energyParams['Time'],
               ak: ENV['HUNAU_API_PARAMS_AK'],
               sign: sign }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end
end
