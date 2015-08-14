class Trick < ActiveRecord::Base
  belongs_to :round
  has_many   :cards

  validates :round, presence: true
end
