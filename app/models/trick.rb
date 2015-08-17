class Trick < ActiveRecord::Base
  belongs_to :round
  has_many   :cards

  validates :round, presence: true
  validates :number_in_round, numericality: { greater_than: 0 }
end
