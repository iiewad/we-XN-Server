class Api::V1::BorrowBookController < ApplicationController
  include Api::ApiHelper

  def index
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_borrow

    borrowParams = {}
    borrowParams['ak'] = ENV['HUNAU_API_PARAMS_AK']
    borrowParams['id'] = params["cardcode"]
    borrowParams['pageindex'] = params["pageindex"]
    borrowParams['pagesize'] = params["pagesize"]

    res = request_helper(borrowParams, uri_str)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: res
    }
  end
end
