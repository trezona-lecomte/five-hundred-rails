class Bid < ActiveRecord::Base
  include HasSuit

  belongs_to :round
  belongs_to :player

  validates :round, :player, :number_of_tricks, :suit, presence: true
end
