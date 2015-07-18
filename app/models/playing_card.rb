class PlayingCard < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_collection

  validates_presence_of :card
  validates_presence_of :card_collection
  validates_uniqueness_of :card, scope: :card_collection_id
end
