namespace :get_tran_item do
  require 'net/http'
  require 'rexml/document'
  include REXML

  desc 'Get TranItem'
  task get_TranItem: :environment do
    params = { ak: ENV['HUNAU_API_PARAMS_AK'], id: '20150902233720207' }

    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_tranitem

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)

    xmldoc = Nokogiri::XML(res.body)
    tranItems = JSON.parse(xmldoc.child.child)["TranItemDTO"]
    tranItems.each do |item|
      TranItem.create(trancode: item["trancode"], tranname: item["tranname"])
    end
  end

end
