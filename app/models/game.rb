class Game < ActiveRecord::Base
  MAX_PLAYERS = 4

  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy
end
