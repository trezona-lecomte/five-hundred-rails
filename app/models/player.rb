class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  has_many :cards, dependent: :destroy
  has_many :bids,  dependent: :destroy

  validates :game, :user, presence: true
  validates :user,        uniqueness: { scope: :game }

  # scope :odd_team, -> { where(number_in_game.odd?) }
  # scope :even_team, -> { where(number_in_game.even?) }
end
