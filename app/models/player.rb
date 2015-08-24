class Player < ActiveRecord::Base
  belongs_to :game, touch: true
  belongs_to :user

  has_many :cards, dependent: :destroy
  has_many :bids,  dependent: :destroy

  validates :game,          presence: true
  validates :user,          presence: true, uniqueness: { scope: :game }
  validates :order_in_game, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
