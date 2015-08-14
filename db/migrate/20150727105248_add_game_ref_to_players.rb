class AddGameRefToPlayers < ActiveRecord::Migration
  def change
    add_reference :players, :game, foreign_key: true
  end
end
