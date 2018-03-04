class Api::V1::NewsController < Api::BaseController

  include Api::ApiHelper

  def index
    request_hunau_api_get_news_list
  end

end
