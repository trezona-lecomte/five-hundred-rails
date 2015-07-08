require 'card'

class Hand < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  has_and_belongs_to_many :cards
end
