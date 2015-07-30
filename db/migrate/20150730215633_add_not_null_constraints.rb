class AddNotNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :cards, :round_id, false
    change_column_null :tricks, :round_id, false
    change_column_null :players, :game_id, false
    change_column_null :rounds, :game_id, false
  end
end
