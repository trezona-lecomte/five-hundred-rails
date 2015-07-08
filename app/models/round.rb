require 'card'

class Round < ActiveRecord::Base
  belongs_to :game
  has_many :tricks
  has_many :hands

  serialize :kitty, Array

  after_initialize { self.kitty ||= [] }
end
