class Round < ActiveRecord::Base
  NUMBER_OF_TRICKS = 10

  belongs_to :game, touch: true
  has_many   :cards,  dependent: :destroy
  has_many   :tricks, dependent: :destroy
  has_many   :bids,   dependent: :destroy

  validates :game, presence: true
  validates :odd_team_score, :even_team_score, numericality: { only_integer: true}

  scope :in_playing_order, -> { order(number_in_game: :asc) }

  def in_bidding_stage?
    bids.passes.count < (game.players.count - 1)
  end

  def in_playing_stage?
    !in_bidding_stage? && current_trick
  end

  def finished?
    !current_trick
  end

  def current_trick
    tricks.active.in_playing_order.first
  end

  def previous_trick
    tricks.inactive.in_playing_order.last
  end

  def highest_bid
    bids.in_ranked_order.first
  end
end
