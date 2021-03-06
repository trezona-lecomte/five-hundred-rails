class Round < ActiveRecord::Base
  NUMBER_OF_TRICKS = 10

  belongs_to :game, touch: true
  has_many :cards,  dependent: :destroy
  has_many :tricks, dependent: :destroy
  has_many :bids,   dependent: :destroy

  validates :game, presence: true
  validates :order_in_game, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :odd_players_score, :even_players_score, presence: true,
                                                     numericality: { only_integer: true }

  scope :in_playing_order, -> { order(order_in_game: :asc) }

  def in_bidding_stage?
    bids.passes.count < game.players.count - 1
  end

  def in_playing_stage?
    !in_bidding_stage? && tricks.active.any?
  end

  def finished?
    tricks.active.none?
  end

  def current_trick
    tricks.active.in_playing_order.first
  end

  def previous_trick
    tricks.inactive.in_playing_order.last
  end

  def highest_bid
    bids.non_passes.in_ranked_order.first
  end

  def has_no_bids_yet?
    bids.count.zero?
  end
end
