class AttackScore
  OFFENSIVE_TRICK_MULTIPLIER = 100
  BASE_SCORES = {
    Card.suits[:spades]   =>  40,
    Card.suits[:clubs]    =>  60,
    Card.suits[:diamonds] =>  80,
    Card.suits[:hearts]   => 100,
    Card.suits[:no_suit]  => 120
  }

  def initialize(attempted_number_of_tricks:, attempted_suit:, number_of_tricks_won:)
    @attempted_number_of_tricks = attempted_number_of_tricks
    @number_of_tricks_won = number_of_tricks_won
    @attempted_suit = attempted_suit
  end

  def score
    @number_of_tricks_won >= @attempted_number_of_tricks ? score_for_attack : -score_for_attack
  end

  private

  def score_for_attack
    BASE_SCORES[Card.suits[@attempted_suit]] +
      ((@attempted_number_of_tricks - Bid::MIN_TRICKS) * OFFENSIVE_TRICK_MULTIPLIER)
  end
end
