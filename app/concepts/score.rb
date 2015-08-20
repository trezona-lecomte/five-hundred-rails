class Score
  DEFENSIVE_TRICK_MULTIPLIER = 10
  OFFENSIVE_TRICK_MULTIPLIER = 100
  BASE_SCORES = { Card.suits[:spades]   =>  40,
                  Card.suits[:clubs]    =>  60,
                  Card.suits[:diamonds] =>  80,
                  Card.suits[:hearts]   => 100,
                  Card.suits[:no_suit]  => 120  }

  attr_reader :number_of_tricks, :suit

  def initialize(number_of_tricks:, suit: Card.suits[:no_suit])
    @number_of_tricks = number_of_tricks
    @suit = suit
  end

  def for_successful_attack
    for_attack
  end

  def for_failed_attack
    -for_attack
  end

  def for_defense
    number_of_tricks * DEFENSIVE_TRICK_MULTIPLIER
  end

  private

  def for_attack
    BASE_SCORES[Card.suits[suit]] + ((number_of_tricks - Bid::MIN_TRICKS) * OFFENSIVE_TRICK_MULTIPLIER)
  end
end
