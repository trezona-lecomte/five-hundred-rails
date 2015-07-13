class Action < ActiveRecord::Base
  BID = "bid"
  PLAY_CARD = "play_card"

  belongs_to :round
  belongs_to :player

  validates :action_type, inclusion: { in: %w{bid play_card} }

  scope :bids,         -> { where(action_type: :bid) }
  scope :played_cards, -> { where(action_type: :play_card) }
end
