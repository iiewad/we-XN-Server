class Api::V1::GetRoomsController < ApplicationController
  def index
    priDormId = params['priDormId'].present? ? params['priDormId'] : ENV['HUNAU_API_PARAMS_PRIDORMID']
    @roomList = Room.where(pridormid: priDormId).select(:id, :dormid, :dormname, :pridormid, :address_type)
    render :json => {
      status: 'success',
      message: '请求成功',
      roomList: @roomList
    }
  end
end
