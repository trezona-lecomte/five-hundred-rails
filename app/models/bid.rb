class Bid < ActiveRecord::Base
  # include Comparable
  include Suits

  belongs_to :player
  belongs_to :round

  validates_numericality_of :tricks, only_integer: true, greater_than: -1
  validates_inclusion_of :suit, in: Suits::ALL_SUITS

  scope :most_recent_bid, -> { where("tricks > 0").order("created_at desc").limit(1).first }
  scope :most_recent_bid_or_pass, -> { order("created_at desc").limit(1).first }
  scope :passes, -> { where(tricks: 0) }

  # def <=>(other)

  # end
end
