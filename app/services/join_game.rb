class JoinGame
  include ActiveModel::Validations

  attr_reader :player

  validate :game_can_be_joined

  def initialize(game:, user:)
    @game = game
    @user = user
    @player = nil
  end

  def call
    @game.with_lock do
      valid? && join_game!
    end
  end

  private

  def game_can_be_joined
    errors.add(:base, "no more than #{Game::MAX_PLAYERS} players can join") if game_full?
  end

  def game_full?
    @game.players.count == Game::MAX_PLAYERS
  end

  def join_game!
    begin
      @player = @game.players.create!(user: @user,
                                      handle: @user.username,
                                      order_in_game: @game.players.count)

    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.messages.each do |msg|
        errors.add(:base, msg)
      end
    end
  end
end
