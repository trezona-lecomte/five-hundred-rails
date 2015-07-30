class Hand < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  has_many :cards, dependent: :destroy
end
