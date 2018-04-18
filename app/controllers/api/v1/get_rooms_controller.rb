class Api::V1::GetRoomsController < ApplicationController
  def index
    priDormId = params['priDormId'].present? ? params['priDormId'] : ENV['HUNAU_API_PARAMS_PRIDORMID']
    roomList = Room.where(pridormid: priDormId).select(:id, :dormid, :dormname, :pridormid, :address_type)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: roomList
    }
  end

  def get_room_list
    pridorm_id = params['priDormId']
    apartment = Room.where(dormid: pridorm_id).select(:id, :dormid, :dormname, :roomid, :roomaccountid, :pridormid, :address_type).first

    redis = Redis.new

    if redis.hexists('room_lists', apartment.dormname)
      room_lists = redis.hget('room_lists', apartment.dormname)
      room_lists = JSON.parse(room_lists.gsub('=>', ':'))
    else
      room_lists = {}
      room_lists['apartment'] = apartment.as_json

      build_lists = Room.where(pridormid: apartment.dormid).select(:id, :dormid, :dormname, :roomid, :roomaccountid, :pridormid, :address_type).as_json
      room_lists['apartment']['build'] = build_lists

      room_lists['apartment']['build'].each do |b_list|
        b_list['floor'] = Room.where(pridormid: b_list['dormid']).select(:id, :dormid, :dormname, :roomid, :roomaccountid, :pridormid, :address_type).as_json
        b_list['floor'].each do |f_list|
          f_list['room'] = Room.where(pridormid: f_list['dormid']).select(:id, :dormid, :dormname, :roomid, :roomaccountid, :pridormid, :address_type).as_json
          f_list['room'].each do |next_room|
            next_room['next_room'] = Room.where(pridormid: next_room['dormid']).select(:id, :dormid, :dormname, :roomid, :roomaccountid, :pridormid, :address_type).as_json
          end
        end
      end
      redis.hset('room_lists', apartment.dormname, room_lists)
    end


    render :json => {
      status: 'success',
      message: '请求成功',
      data: room_lists
    }
  end

end
