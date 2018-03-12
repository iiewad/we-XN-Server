namespace :grades do
  require 'net/http'

  desc 'Get Grades'
  task get_grades_from_hunauapi: :environment do
    handle_grade
  end

  def request_hunau_api_get_stuGrades
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_post_endpoint +
              Settings.hunauapi.service_grades_endpoint

    sign = "userId=#{ENV['HUNAU_API_PARAMS_NEWS_ID']}CardCode=#{ENV['HUNAU_API_PARAMS_NEWS_ID']}XN=XQ=#{ENV['HUNAU_API_PARAMS_AK']}"
    sign = Digest::MD5.hexdigest sign

    params = { callback: Settings.hunauapi.callback,
               userId: ENV['HUNAU_API_PARAMS_USER_FLAG'],
               CardCOde: ENV['HUNAU_API_PARAMS_USER_FLAG'],
               XN: '',
               XQ: '',
               ak: ENV['HUNAU_API_PARAMS_AK'],
               sign: sign,
               _: ENV['HUNAU_API_PARAMS_GRADE__'] }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def handle_grade
    strGrades = request_hunau_api_get_stuGrades
    strGrades.gsub!('loadCJ_JsonpCallback(', '').chop!
    strGrades = JSON.parse(strGrades)

    if strGrades["Status"].to_i == 1
      strGrades["rList"].each do |grades|
        StuGrade.create!(xn: grades["XN"],
                         xq: grades["XQ"],
                         xh: grades["XH"],
                         xm: grades["XM"],
                         kcmc: grades["KCMC"],
                         xf: grades["XF"],
                         cj: grades["CJ"],
                         kcxz: grades["KCXZ"] )
        puts '.'
      end
    end

  end

end
