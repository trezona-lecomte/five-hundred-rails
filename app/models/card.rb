class Card < ActiveRecord::Base
  enum suit: %w(spades clubs diamonds hearts no_suit)
  enum rank: { "2"     => 2,
               "3"     => 3,
               "4"     => 4,
               "5"     => 5,
               "6"     => 6,
               "7"     => 7,
               "8"     => 8,
               "9"     => 9,
               "10"    => 10,
               "jack"  => 11,
               "queen" => 12,
               "king"  => 13,
               "ace"   => 14,
               "joker" => 15 }

  belongs_to :player
  belongs_to :round
  belongs_to :trick, counter_cache: true

  validates :round, :rank, :suit, presence: true
  validates :round,               uniqueness: { scope: [:rank, :suit] }

  # TODO maybe use order_played:
  validates :number_in_trick,     uniqueness: { scope: [:trick], allow_nil: true }

  scope :played,           -> { where.not(trick: nil) }
  scope :unplayed,         -> { where(trick: nil) }
  scope :in_ranked_order,  -> { order(rank: :desc, suit: :desc) }
  scope :highest,          -> { in_ranked_order.first }
  scope :in_playing_order, -> { where.not(number_in_trick: nil).order(number_in_trick: :asc) }
  scope :last_played,      -> { in_playing_order.last }
end
