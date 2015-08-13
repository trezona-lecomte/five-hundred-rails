class AddNumberInGameToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :number_in_game, :integer
  end
end
