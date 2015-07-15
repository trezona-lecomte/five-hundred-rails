class CardCollection < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  has_many :playing_cards
end
