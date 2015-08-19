class JoinGame
  attr_reader :errors

  # TODO maybe put named args back in - it'll complain earlier (in initialize) rather than when you use the objs.
  def initialize(game, user)
    @game = game
    @user = user
    @errors = []
  end

  def call
    # TODO: check whether with_lock reloads the object.
    @game.with_lock do
      validate_game_can_be_joined

      if errors.none?
        join_game
      end

      errors.none?
    end
  end

  private

  def validate_game_can_be_joined
    if @game.players.count < Game::MAX_PLAYERS
      return true
    else
      add_error("no more than #{Game::MAX_PLAYERS} players can join this game")
      false
    end
  end

  def join_game
    @player = @game.players.new(user: @user, handle: @user.username, number_in_game: @game.players.count + 1)

    unless @player.save
      add_error("user is unable to join this game: " + @player.errors) # TODO: look into full_sentences
      # TODO also interpolate errors into the string ^^
    end
  end

  def add_error(message)
    @errors << message
  end
end
