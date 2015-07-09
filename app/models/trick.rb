class Trick < ActiveRecord::Base
  belongs_to :round
  has_many :cards

  validates :cards, length: { maximum: 4 }
end
