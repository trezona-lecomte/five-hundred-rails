class JoinGame
  attr_reader :errors, :player

  def initialize(game:, user:)
    @game = game
    @user = user
    @player = nil
    @errors = []
  end

  def call
    @game.with_lock do
      validate_game_can_be_joined

      if errors.none?
        join_game
      end
    end

    errors.none?
  end

  private

  def validate_game_can_be_joined
    if @game.players.count < Game::MAX_PLAYERS
      return true
    else
      add_error("no more than #{Game::MAX_PLAYERS} players can join this game")
    end
  end

  def join_game
    @player = @game.players.new(user: @user,
                                handle: @user.username,
                                order_in_game: @game.players.count)

    unless @player.save
      @player.errors.full_messages.each do |message|
        add_error(message)
      end
    end
  end

  def add_error(message)
    @errors << message
  end
end
