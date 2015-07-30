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

    success?
  end

  private

  def round_can_be_started
    # TODO: implement validations for starting round
    true
  end

  def start_round
    @round = @game.rounds.new

    first_trick = @round.tricks.new

    unless @round.save && first_trick.save
      add_error("failed to start the round")
    end
  end

  def success?
    @errors.empty?
  end

  def add_error(message)
    @errors << message
  end
end
