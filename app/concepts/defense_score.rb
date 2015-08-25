class DefenseScore
  DEFENSIVE_TRICK_MULTIPLIER = 10

  def initialize(number_of_tricks_won:)
    @number_of_tricks_won = number_of_tricks_won
  end

  def score
    @number_of_tricks_won * DEFENSIVE_TRICK_MULTIPLIER
  end
end
