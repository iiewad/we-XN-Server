class StuUser < ApplicationRecord
  validates :cardcode, :schno, presence: true,
                               uniqueness: true
end
