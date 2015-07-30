class AddNotNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :cards, :hand_id, false
    change_column_null :tricks, :round_id, false
    change_column_null :hands, :player_id, false
    change_column_null :hands, :round_id, false
    change_column_null :players, :game_id, false
    change_column_null :rounds, :game_id, false
  end
end
