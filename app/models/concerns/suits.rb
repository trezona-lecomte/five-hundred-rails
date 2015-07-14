module Suits
  extend ActiveSupport::Concern

  included do
    NO_TRUMPS ||= "no trumps"
    HEARTS    ||= "hearts"
    DIAMONDS  ||= "diamonds"
    CLUBS     ||= "clubs"
    SPADES    ||= "spades"
    ALL_SUITS ||= [NO_TRUMPS, HEARTS, DIAMONDS, CLUBS, SPADES]
  end

  class_methods do
    def higher_suit(a, b)
      return false if a == b

      ALL_SUITS.find { |suit| suit == a || suit == b }
    end
  end
end
