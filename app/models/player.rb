class Player < ActiveRecord::Base
  belongs_to :game
  has_many :cards, dependent: :destroy

  validates :game, presence: true
end
