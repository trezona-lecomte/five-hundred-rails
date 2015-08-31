class Player < ActiveRecord::Base
  belongs_to :game, inverse_of: :players, touch: true
  belongs_to :user, inverse_of: :players

  has_many :cards, inverse_of: :player, dependent: :destroy
  has_many :bids,  inverse_of: :player, dependent: :destroy

  validates :game,          presence: true
  validates :user,          presence: true, uniqueness: { scope: :game }
  validates :order_in_game, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
