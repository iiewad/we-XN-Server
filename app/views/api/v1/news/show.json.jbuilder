json.data do
  json.id @news.id
  json.title @news.title
  json.summary @news.summary
  json.addtime @news.addtime
  json.content @news.content
end
