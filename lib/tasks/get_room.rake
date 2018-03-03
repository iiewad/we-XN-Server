namespace :get_room_info do
  desc 'Get Room'
  task get_room_info: :environment do
    get_apartment
    get_build
    get_floor
    get_room
  end

  def get_apartment
    request_hunau_api_get_room( ENV['HUNAU_API_PARAMS_PRIDORMID'], 'apartment' )
  end

  def get_build
    Room.where(address_type: 'apartment').each do |apartment|
      request_hunau_api_get_room( apartment.dormid, 'build')
    end
    puts '/'
  end

  def get_floor
    Room.where(address_type: 'build').each do |build|
      request_hunau_api_get_room( build.dormid, 'floor' )
    end
    puts '*'
  end

  def get_room
    Room.where(address_type: 'floor').each do |room|
      request_hunau_api_get_room( room.dormid, 'room' )
    end
    puts '%'
  end

  def request_hunau_api_get_room( pridormid, address_type )
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_post_endpoint +
              Settings.hunauapi.get_room_path
    user = StuUser.first
    sign_str = "userId=#{user.cardcode}PriDormID=#{pridormid}#{ENV['HUNAU_API_PARAMS_AK']}"
    sign = Digest::MD5.hexdigest sign_str
    params = { ak: ENV['HUNAU_API_PARAMS_AK'], userId: user.cardcode, PriDormID: pridormid, sign: sign }

    uri = URI.parse(uri_str)

    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri)
    request["accept"] = 'application/xml'
    request["content-type"] = 'application/x-www-form-urlencoded'
    request.body = URI.encode_www_form(params)

    response = http.request(request)
    res = Nokogiri::XML response.read_body
    res = JSON.parse(res.child.child.to_s)

    if res["Status"].to_i.zero?
      return false
    else
      roomList = res["rList"]
      roomList.each do |list|
        list_tmp = list.map { |k, v| [k.downcase, v] }.to_h
        list_tmp['pridormid'] = pridormid
        list_tmp['address_type'] = address_type
        room = Room.new(list_tmp)
        room.save!
        puts '.'
      end
    end

  end

end
