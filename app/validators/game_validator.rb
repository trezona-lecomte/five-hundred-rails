class GameValidator < ActiveModel::Validator
  def validate(game)
    return true if game.players.size < 5
    game.errors[:base] << "cannot have more than 4 players"
  end
end