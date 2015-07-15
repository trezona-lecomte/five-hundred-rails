require_dependency "suits"

class Card < ActiveRecord::Base
  validates :suit, inclusion: { in: Suits::ALL_SUITS }
end
