class StuUser < ApplicationRecord
  validates :cardcode, :schno, presence: true,
                               uniqueness: true
  validates :idcard, uniqueness: true
end
