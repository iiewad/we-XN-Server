class News < ApplicationRecord
  validates :news_id, uniqueness: true
end
