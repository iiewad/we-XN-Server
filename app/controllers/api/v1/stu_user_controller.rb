class Api::V1::StuUserController < ApplicationController
  skip_before_action :verify_authenticity_token

  def bind_room
    user = StuUser.find_by(cardcode: params['cardcode'])
    user.dorm = {
      apartment_id: params['apartment_id'],
      build_direction_id: params['build_direction_id'],
      build_id: params['build_id'],
      floor_id: params['floor_id'],
      room_id: params['room_id']
    }
    if user.save
      render :json => {
        status: 'success',
        message: '请求成功',
        data: user.dorm
      }
    else
      render :json => {
        status: 'failed',
        message: '绑定失败',
        error_message: user.errors.messages
      }
    end
  end
end
