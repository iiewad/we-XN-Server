class Api::V1::BindStuUserController < Api::BaseController

  require 'uri'
  require 'net/http'

  include Api::ApiHelper

  def index
    user = StuUser.find_by(schno: private_params["stu_number"])
    if user && user.authenticate(private_params["stu_password"])
      puts '1' * 123
      # self.current_user = user
      if user.wechat_open_id.nil?
        wechat_user_flag = JSON.parse(request_wechat_login_api(params['code']))
        user.update_columns(wechat_open_id: wechat_user_flag["openid"],
                            authentication_token: user.generate_authentication_token)
      end
      user.generate_authentication_token
      render :json => {
        status: 'success',
        userinfo: user.as_json
      }
    else
      puts '*' * 123
      res = request_hunau_api_login(private_params["stu_number"],
                                    private_params["stu_password"])
      login_info_xml = Nokogiri::XML res
      login_info = JSON.parse(login_info_xml.child.child.to_s)

      login_status = login_info["status"].to_i
      if login_status.zero?
        render :json => {
          status: 'failed',
          message_detail: login_info["Msg"]
        }
      else
        wechat_user_flag = JSON.parse(request_wechat_login_api(params['code']))
        wechat_user_flag = "" if wechat_user_flag["errcode"].present?

        user_info = login_info["Userinfo"]
        user_info = user_info.map { |k, v| [k.downcase, v] }.to_h
        user_info["user_type"] = user_info["type"]
        user_info.delete_if { |k, v| k == "type" }
        user_info["wechat_open_id"] = wechat_user_flag["openid"]
        user_info["password"] = private_params["stu_password"]
        user_info["password_confirmation"] = private_params["stu_password"]
        user = StuUser.new(user_info)
        user_info["authentication_token"] = user.generate_authentication_token

        if user.save
          render :json => {
            status: 'success',
            userinfo: user.as_json
          }
        else
          return false
        end
      end
    end
  end
=begin
  def index
    stu_number = params['stu_number']
    stu_password = params['stu_password']

    wechat_urse_flag = JSON.parse(request_wechat_login_api(params['code']))

    res = request_hunau_api_login(stu_number, stu_password)
    login_info_xml = Nokogiri::XML res
    login_info = JSON.parse(login_info_xml.child.child.to_s)

    login_status = login_info["status"].to_i
    if login_status.zero?
      render :json => {
        status: 'failed',
        message: '账号绑定失败',
        message_detail: login_info["Msg"]
      }
    else
      user_info = login_info["Userinfo"]

      user_info = user_info.map { |k, v| [k.downcase, v] }.to_h
      user_info["user_type"] = user_info["type"]
      user_info.delete_if { |k, v| k == "type" }

      user_info["wechat_open_id"] = wechat_urse_flag["openid"]
      user = StuUser.find_by(cardcode: user_info["card_code"])
      user_info["authentication_token"] = user.generate_authentication_token

      if user.wechat_open_id.nil?
        render :json => {
          status: 'failed',
          message: '账号绑定失败',
          message_detail: '账号已绑定过，无须重复绑定'
        }
      else
        user = StuUser.new(user_info)
        user if user.save
        if user.save
          render :json => {
            status: 'success',
            message: '账号绑定成功',
            data: user.as_json
          }
        else
          render :json => {
            status: 'failed',
            message: '账号绑定失败',
            message_detail: user.errors.messages.as_json
          }
        end
      end
    end
  end
=end

  private
    def private_params
      params.require(:stu_user).permit(:stu_number, :stu_password)
    end

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
