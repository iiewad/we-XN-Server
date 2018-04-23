class Api::V1::WxLoginController < ApplicationController
  include Api::ApiHelper

  def index
    wx_login_res = JSON.parse(request_wechat_login_api(params['code']))
    stu_user = StuUser.find_by(wechat_open_id: wx_login_res["openid"])
    if stu_user.nil?
      render :json => {
        status: 'failed',
        message: '登录失败, 未查询到绑定信息'
      }
    else
      # sessionid = SecureRandom.base64(64)
      # redis = Redis.new
      # redis.set(sessionid, wx_login_res["openid"] + wx_login_res["session_key"], ex: 7200)
      render :json => {
        status: 'success',
        message: '请求成功',
        data: stu_user
      }
    end
  end
end
