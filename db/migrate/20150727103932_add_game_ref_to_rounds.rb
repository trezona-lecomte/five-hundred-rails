class AddGameRefToRounds < ActiveRecord::Migration
  def change
    add_reference :rounds, :game, index: true, foreign_key: true
  end
end
