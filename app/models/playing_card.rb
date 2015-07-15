class PlayingCard < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_collection
end
