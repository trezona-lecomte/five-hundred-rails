class StartRound
  attr_reader :errors, :round

  def initialize(game)
    @game = game
    @round = nil
    @errors = []
  end

  def call
    @game.with_lock do
      start_round if round_can_be_started
    end
  end

  private

  def round_can_be_started
    # TODO: implement validations for starting round
    true
  end

  def start_round
    @round = @game.rounds.create!

    Round::NUMBER_OF_TRICKS.times do |n|
      @round.tricks.create!(number_in_round: n)
    end
  end
end
