class Player < ActiveRecord::Base
  belongs_to :game
  has_many :cards, dependent: :destroy
  has_many :bids,  dependent: :destroy

  validates :game, presence: true
end
