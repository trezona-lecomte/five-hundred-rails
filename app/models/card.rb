class Card < ActiveRecord::Base
  include Suits

  belongs_to :card_collection
  belongs_to :trick

  validates :suit, inclusion: { in: ALL_SUITS }
end
