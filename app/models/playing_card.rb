class PlayingCard < ActiveRecord::Base
  belongs_to :card
  belongs_to :hand, class_name: "CardCollection"

  validates_presence_of :card, :card_collection
  validates_uniqueness_of :card, scope: :card_collection_id
end
