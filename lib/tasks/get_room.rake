namespace :get_room_info do
  require 'net/http'
  desc 'Get Apartment'
  task get_apartment: :environment do
    get_apartment
  end

  desc 'Get Build'
  task get_build: :environment do
    get_build
  end

  desc 'Get Floor'
  task get_floor: :environment do
    get_floor
  end

  desc 'Get Room'
  task get_room: :environment do
    get_room
  end

  desc 'Get RoomNumber'
  task get_room_number: :environment do
    get_room_number
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

  def get_room_number
    Room.where(address_type: 'room').where("dormname LIKE '%层'").each do |room_number|
      request_hunau_api_get_room( room_number.dormid, 'room_number')
    end
    puts '@' * 123
  end

  def handle_room_data(response, pridormid, address_type)
    if response.nil?
      puts pridormid
      return false
    end
    if response.code == '200'
      puts '*' * 123
      res = Nokogiri::XML response.read_body
      res = JSON.parse(res.child.child.to_s)
      puts '*' * 123

      if res["Status"].to_i.zero?
        puts 'Debug                 =>       No Data'
        return false
      elsif res["Status"] == "1"
        roomList = res["rList"]
        roomList.each do |list|
          list_tmp = list.map { |k, v| [k.downcase, v] }.to_h
          list_tmp['pridormid'] = pridormid
          list_tmp['address_type'] = address_type
          room = Room.new(list_tmp)
          if room.save
            puts 'Info                 =>        saved Room info'
          else
            puts "Error                =>        #{room.errors.messages}"
          end
        end
      else
        puts res['Message']
      end
    else
      puts 'x' * 123
    end
  end

  def request_hunau_api_get_room( pridormid, address_type )
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_post_endpoint +
              Settings.hunauapi.get_room_path
    userid = '20141114095328475'
    sign_str = "userId=#{userid}PriDormID=#{pridormid}#{ENV['HUNAU_API_PARAMS_AK']}"
    sign = Digest::MD5.hexdigest sign_str
    params = { ak: ENV['HUNAU_API_PARAMS_AK'], userId: userid, PriDormID: pridormid, sign: sign }

    uri = URI.parse(uri_str)

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 1200
      request = Net::HTTP::Post.new(uri)
      request["accept"] = 'application/xml'
      request["content-type"] = 'application/x-www-form-urlencoded'
      request.body = URI.encode_www_form(params)
      response = http.request(request)
    rescue Exception => e
      Rails.logger.error("宿舍信息获取失败 => #{e.inspect}")
      sleep 10
      retry
    end

    handle_room_data(response, pridormid, address_type)
  end

end
