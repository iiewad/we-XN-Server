class Api::V1::WechatLoginController < ApplicationController

  def index
    request_wechat_login_api(params['code'])
  end

  private
    def request_wechat_login_api(js_code)
      params = {
        appid: ENV['WECHAT_APPID'],
        secret: ENV['WECHAT_APPSECRET'],
        js_code: js_code,
        grant_type: Settings.wechatapi.grant_type
      }

      uri_str = Settings.wechatapi.service_host + URI.encode_www_form(params)
      url = URI.parse(uri_str)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)

      response = http.request(request)
      response.read_body
    end
end
