class StuUser < ApplicationRecord
  has_many :feedbacks

  validates :cardcode, :schno, presence: true,
                               uniqueness: true

  store :dorm, accessors: [:apartment_id, :build_direction_id, :build_id, :floor_id, :room_id]

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break if !StuUser.find_by(authentication_token: authentication_token)
    end
  end

  def reset_auth_token!
    generate_authentication_token
    save
  end

end
