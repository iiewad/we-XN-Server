class Room < ApplicationRecord
  validates :dormid, uniqueness: true
end
