class Api::V1::GetBrowsController < ApplicationController

  include Api::ApiHelper

  def index
    queryParams = JSON.parse(params["queryParams"])
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_brows
    queryParams["SessionId"] = ''
    queryParams["ak"] = ENV['HUNAU_API_PARAMS_AK']
    res = request_helper(queryParams, uri_str)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: res
    }
  end

  def loss
    queryParams = JSON.parse(params["queryParams"])
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_loss
    queryParams["ak"] = ENV['HUNAU_API_PARAMS_AK']
    res = request_helper(queryParams, uri_str)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: res
    }
  end
end
