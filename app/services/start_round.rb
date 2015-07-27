class StartRound
  def initialize(game, round)
    @game = game
    @round = round
  end

  def call
    @game.with_lock do
      start_round if round_can_be_started
    end

    success?
  end

  private

  def round_can_be_started
    true
  end

  def start_round
    @game.rounds.new(players: @game.players)

    @round.save
  end

  def success?
    @round.errors.empty?
  end
end
