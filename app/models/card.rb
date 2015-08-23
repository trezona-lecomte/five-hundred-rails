class Card < ActiveRecord::Base
  enum suit: Suits::ALL_SUITS
  enum rank: {
    "2"     => 2,
    "3"     => 3,
    "4"     => 4,
    "5"     => 5,
    "6"     => 6,
    "7"     => 7,
    "8"     => 8,
    "9"     => 9,
    "10"    => 10,
    "11"    => 11,
    "12"    => 12,
    "13"    => 13,
    "jack"  => 14,
    "queen" => 15,
    "king"  => 16,
    "ace"   => 17,
    "joker" => 18
  }

  belongs_to :player
  belongs_to :round, touch: true
  belongs_to :trick, counter_cache: true, touch: true

  validates :rank, :suit, presence: true
  validates :round,       presence: true, uniqueness: { scope: [:rank, :suit] }
  validates :order_in_trick,              uniqueness: { scope: [:trick], allow_nil: true }

  scope :played,           -> { where.not(trick: nil) }
  scope :unplayed,         -> { where(trick: nil) }
  scope :in_ranked_order,  -> { order(rank: :desc, suit: :desc) }
  scope :highest,          -> { in_ranked_order.first }
  scope :in_playing_order, -> { played.order(order_in_trick: :asc) }
  scope :last_played,      -> { in_playing_order.last }
end
