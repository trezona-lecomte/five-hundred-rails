require_dependency 'suits'

class Card < ActiveRecord::Base
  belongs_to :card_collection
  belongs_to :trick

  validates :suit, inclusion: { in: Suits::ALL_SUITS }
end
