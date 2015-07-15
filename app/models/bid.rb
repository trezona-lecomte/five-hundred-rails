require_dependency 'suits'

class Bid < ActiveRecord::Base
  belongs_to :player
  belongs_to :round

  validates_numericality_of :tricks, only_integer: true, greater_than: -1
  validates_inclusion_of :suit, in: Suits::ALL_SUITS

  scope :most_recent, -> { order("created_at desc") }
  scope :non_passes,  -> { where("tricks > 0") }
  scope :passes,      -> { where(tricks: 0) }
end
