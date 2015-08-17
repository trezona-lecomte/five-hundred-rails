class Bid < ActiveRecord::Base
  include HasSuit

  belongs_to :round
  belongs_to :player

  validates :round, :player, :number_of_tricks, :suit, presence: true

  scope :passes,          -> { where(number_of_tricks: 0) }
  scope :in_ranked_order, -> { order(number_of_tricks: :desc, suit: :desc) }
end
