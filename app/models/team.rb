class Team < ActiveRecord::Base
  MAX_PLAYERS = 2

  belongs_to :game
  has_many :players, dependent: :destroy

  validates :number, presence: true,
                     numericality: { only_integer: true,
                                     greater_than: 0 }
end
