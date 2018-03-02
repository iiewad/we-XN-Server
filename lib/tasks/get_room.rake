namespace :get_room do
  desc 'Get The Room'

  task get_apartment: :environment do
    request_hunau_api_get_room
  end

  def request_hunau_api_get_room
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_post_endpoint +
              Settings.hunauapi.get_room_path
    user = StuUser.first
    sign_str = "userId=#{user.cardcode}PriDormID=#{ENV['HUNAU_API_PARAMS_PRIDORMID']}#{ENV['HUNAU_API_PARAMS_AK']}"
    sign = Digest::MD5.hexdigest sign_str
    params = { ak: ENV['HUNAU_API_PARAMS_AK'], userId: user.cardcode, PriDormID: ENV['HUNAU_API_PARAMS_PRIDORMID'], sign: sign }

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
        room = Room.new(list_tmp)
        room.save!
        puts '.'
      end
    end

  end

end
