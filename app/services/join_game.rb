class JoinGame
  def initialize(game, handle)
    @game = game
    @handle = handle
  end

  def call
    @game.with_lock do
      join_game if game_can_be_joined
    end

    success?
  end

  private

  def game_can_be_joined
    return true if @game.players.count < Game::MAX_PLAYERS

    @game.errors.add(:players, "can't be more than #{Game::MAX_PLAYERS}")

    false
  end

  def join_game
    @game.players.new(handle: @handle)

    @game.save
  end

  def success?
    @game.errors.empty?
  end
end
