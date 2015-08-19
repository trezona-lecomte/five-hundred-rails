class Card < ActiveRecord::Base
  include HasSuit
  # TODO explicitly map:
  enum rank: %w(0 1 2 3 4 5 6 7 8 9 10 jack queen king ace joker)

  belongs_to :player
  belongs_to :round
  belongs_to :trick, counter_cache: true

  validates :round, :rank, :suit, presence: true
  validates :round,               uniqueness: { scope: [:rank, :suit] }

  # TODO maybe use order_played:
  validates :number_in_trick,     uniqueness: { scope: [:trick], allow_nil: true }

  scope :highest_to_lowest, -> { order(rank: :desc, suit: :desc) }
  scope :highest,           -> { highest_to_lowest.first }
  # TODO make a scope to represent played_cards - number_in_trick: not nil
  scope :newest_to_oldest,  -> { where.not(number_in_trick: nil).order(number_in_trick: :desc) }
  scope :last_played,       -> { newest_to_oldest.first }
end
