class Card < ActiveRecord::Base
  include Ranks, Suits

  enum suit: ALL_SUITS
  enum rank: {
    TWO      => 2,
    THREE    => 3,
    FOUR     => 4,
    FIVE     => 5,
    SIX      => 6,
    SEVEN    => 7,
    EIGHT    => 8,
    NINE     => 9,
    TEN      => 10,
    ELEVEN   => 11,
    TWELVE   => 12,
    THIRTEEN => 13,
    JACK     => 14,
    QUEEN    => 15,
    KING     => 16,
    ACE      => 17,
    JOKER    => 18
  }

  belongs_to :player, inverse_of: :cards
  belongs_to :round,  inverse_of: :cards, touch: true
  belongs_to :trick,  inverse_of: :cards, counter_cache: true, touch: true

  validates :rank, :suit, presence: true
  validates :round,       presence: true, uniqueness: { scope: [:rank, :suit] }
  validates :order_in_trick, uniqueness:   { scope: [:trick],             allow_nil: true },
                             numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  scope :played,           -> { where.not(trick: nil) }
  scope :unplayed,         -> { where(trick: nil) }
  scope :in_ranked_order,  -> { order(rank: :desc, suit: :desc) }
  scope :in_playing_order, -> { played.order(order_in_trick: :asc) }

  def played?
    trick_id.present?
  end

  def self.highest
    in_ranked_order.first
  end

  def self.last_played
    in_playing_order.last
  end
end
