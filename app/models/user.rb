class User < ActiveRecord::Base
  has_many :players

  before_create -> { self.auth_token = SecureRandom.hex }
end
