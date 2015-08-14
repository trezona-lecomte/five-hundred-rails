class Card < ActiveRecord::Base
  include HasSuit

  belongs_to :player
  belongs_to :round
  belongs_to :trick

  enum rank: %w(0 1 2 3 4 5 6 7 8 9 10 jack queen king ace joker)

  validates :round, :rank, :suit, presence: true
  validates :round,               uniqueness: { scope: [:rank, :suit] }
  validates :number_in_trick,     uniqueness: { scope: [:trick], allow_nil: true }
end
