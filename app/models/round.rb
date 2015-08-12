class Round < ActiveRecord::Base
  NUMBER_OF_TRICKS = 10

  belongs_to :game
  has_many   :cards,  dependent: :destroy
  has_many   :tricks, dependent: :destroy
  has_many   :bids,   dependent: :destroy

  validates :game, presence: true
end
