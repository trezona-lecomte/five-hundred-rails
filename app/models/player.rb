class Player < ActiveRecord::Base
  belongs_to :game, touch: true
  belongs_to :user

  has_many :cards, dependent: :destroy
  has_many :bids,  dependent: :destroy

  validates :game, presence: true
  validates :user, presence: true, uniqueness: { scope: :game }
end
