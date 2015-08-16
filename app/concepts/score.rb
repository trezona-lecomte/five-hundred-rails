class Score
  BASE_SCORES = { Card.suits[:spades]   =>  40,
                  Card.suits[:clubs]    =>  60,
                  Card.suits[:diamonds] =>  80,
                  Card.suits[:hearts]   => 100,
                  Card.suits[:no_suit]  => 120  }

  def self.calculate_for_winners(number_of_tricks, suit)
    BASE_SCORES[Card.suits[suit]] + tricks_score(number_of_tricks)
  end

  def self.calculate_for_losers(number_of_tricks)
    number_of_tricks * 10
  end

  private

  def self.tricks_score(number_of_tricks)
    (number_of_tricks - 6) * 100
  end
end
