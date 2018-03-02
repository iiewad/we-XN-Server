class Api::V1::BindStuUserController < Api::BaseController

  require 'uri'
  require 'net/http'

  include Api::ApiHelper

  def index
    stu_number = params['stu_number']
    stu_password = params['stu_password']

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

      user = StuUser.find_by(cardcode: user_info["card_code"])
      if user
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
end
