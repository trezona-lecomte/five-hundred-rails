class Round < ActiveRecord::Base
  belongs_to :game
  has_many   :cards,  dependent: :destroy
  has_many   :tricks, dependent: :destroy
  has_many   :bids,   dependent: :destroy

  validates :game, presence: true

  def hands
    cards.includes(:player).where("player_id is not null").group_by { |card| card.player }
  end

  def kitty
    cards.includes(:player).where("player_id is null").group_by { |card| card.player }
  end

  def passes
    bids.includes(:player).where(number_of_tricks: 0)
  end
end
