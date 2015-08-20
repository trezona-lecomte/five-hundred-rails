class Card < ActiveRecord::Base
  include Suits, Ranks
  enum suit: ALL_SUITS
  enum rank: EXTENDED_RANKS_AND_VALUES

  belongs_to :player
  belongs_to :round, touch: true
  belongs_to :trick, counter_cache: true, touch: true

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
