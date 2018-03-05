json.data do
  json.set! :page do
    json.current_page params[:page].to_i.zero? ? 1 : params[:page].to_i
    json.page_size    params[:per].to_i.zero? ? News::DEFAULT_PER : params[:per]
    json.total_pages  @news.total_pages
    json.total        @news.count
  end

  json.news @news do |news|
    json.id news.id
    json.title news.title
    json.summary news.summary
    json.adddate news.addtime
  end
end
