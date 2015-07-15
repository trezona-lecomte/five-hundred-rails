require_dependency 'suits'

module Decks
  def self.standard_kitty_size
    3
  end

  def self.standard_hand_size
    10
  end

  def self.standard_deck
    cards = [
        { number: 4, suit: Suits::HEARTS },
        { number: 4, suit: Suits::DIAMONDS },
      ]

    [Suits::HEARTS, Suits::DIAMONDS, Suits::CLUBS, Suits::SPADES].each do |suit|
      (5..14).to_a.each do |number|
        cards << { number: number, suit: suit }
      end
    end

    cards << { number: 15, suit: Suits::NO_TRUMPS }
  end

end
