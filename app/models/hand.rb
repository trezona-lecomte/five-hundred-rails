class Hand < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  has_many :cards, dependent: :destroy

  validates :player, :round, presence: true
end
