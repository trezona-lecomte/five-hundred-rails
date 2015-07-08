require 'card'

class Hand < ActiveRecord::Base
  belongs_to :player
  belongs_to :round

  serialize :cards, Array

  after_initialize { self.cards ||= [] }
end
