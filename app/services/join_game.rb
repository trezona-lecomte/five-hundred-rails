class JoinGame
  attr_reader :errors

  def initialize(game, user)
    @game = game
    @user = user
  end

  def call
    @game.with_lock do
      validate_game_can_be_joined

      unless errors.present?
        join_game
      end
    end
  end

  private

  def validate_game_can_be_joined
    if @game.players.count < Game::MAX_PLAYERS
      return true
    else
      add_error("no more than #{Game::MAX_PLAYERS} can join this game")
      false
    end
  end

  def join_game
    @player = @game.players.new(user: @user, handle: @user.username, number_in_game: @game.players.count + 1)

    unless @player.save
      add_error("user is unable to join this game: " + @player.errors)
    end
  end

  def add_error(message)
    @errors << message
  end
end
