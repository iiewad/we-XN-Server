class StuUser < ApplicationRecord
  has_many :feedbacks

  validates :cardcode, :schno, presence: true,
                               uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

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
