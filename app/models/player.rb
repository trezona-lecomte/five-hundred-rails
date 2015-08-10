class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :cards, dependent: :destroy
  has_many :bids,  dependent: :destroy

  validates :game, presence: true
end
