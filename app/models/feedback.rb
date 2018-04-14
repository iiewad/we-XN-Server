class Feedback < ApplicationRecord
  belongs_to :stu_user
  validates :title, presence: true,
                    uniqueness: true
  validates :content, presence: true,
                      uniqueness: true
end
