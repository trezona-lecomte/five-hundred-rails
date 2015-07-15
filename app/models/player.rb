class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :game
  has_many   :hands,  class_name: "CardCollection"
  has_many   :rounds, through: :hands
  has_many   :bids

  validates :user, presence: true
  validates_uniqueness_of :user, scope: :game
  validates :table_position, numericality: { only_integer: true,
                                     greater_than: 0 }
end
