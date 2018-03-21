namespace :get_news do
  require 'net/http'
  require 'rexml/document'
  include REXML

  desc 'Get All News'
  task get_all_news_from_hunauapi: :environment do
    counter = 0
    235.times do
      pages = { index: counter, size: 20 }
      news_list = request_hunau_api_get_news_list(pages)
      handle_news_list(news_list)
      get_news_content
      counter += 1
      sleep(3.second)
      puts '*'
    end
    puts "Got" + counter  + "Times"
  end

  desc 'Get Newest News'
  task get_newest_news: :environment do
    pages = { index: 0, size: 10 }
    news_list = request_hunau_api_get_news_list(pages)
    handle_news_list(news_list)
    get_news_content
    puts '*'
  end

  def request_hunau_api_get_news_list(pages)
    uri_str = Settings.hunauapi.service_host +
      Settings.hunauapi.service_endpoint +
      Settings.hunauapi.get_news_path

    params = { res: 20,
               id: ENV['HUNAU_API_PARAMS_NEWS_ID'],
               vid: ENV['HUNAU_API_PARAMS_VID'],
               Access_Token: ENV['HUNAU_API_PARAMS_AK'],
               type: 5,
               pageindex: pages[:index],
               pagesize: pages[:size] }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def handle_news_list(news_list)
    xmldoc = Nokogiri::XML(news_list)

    xmldoc.xpath("Response/News/new").each do |e|
      news = News.new(news_id: e.xpath('id').children.text.strip,
                      title: e.xpath('Title').children.text.strip,
                      isuser: e.xpath('IsUser').children.text.strip,
                      summary: e.xpath('summary').children.text.strip,
                      addtime: e.xpath('addtime').children.text.strip,
                      comment_count: e.xpath('CommentCount').children.text.strip,
                      pic_path: URI::decode(e.xpath('Pic').children.text.strip),
                      big_pic_path: URI::decode(e.xpath('bigPic').children.text.strip) )
      if news.save
        puts '.'
      else
        puts 'x'
      end
    end
  end

  def get_news_content
    News.where(content: nil).each do |news|
      news_content = JSON.parse(request_news_content_api(news.news_id))["RList"]
      content = Hash[*news_content]
      unless content.empty?
        content = content["Content"].force_encoding 'gbk'
        content = content.encode
        news.update_columns(content: content)
      end
    end
  end

  def request_news_content_api(news_id)
    uri_str = Settings.hunauapi.service_news_host +
      Settings.hunauapi.service_news_endpoint

    user_id = StuUser.first.cardcode
    params = { action: 'LoadData',
               id: news_id,
               uid: user_id,
               sign: ENV['HUNAU_API_PARAMS_AK'],
               Ntype: '' }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

end
