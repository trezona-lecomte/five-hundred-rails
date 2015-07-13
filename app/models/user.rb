class User < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :games, through: :players

  validates :username, presence: true
end
