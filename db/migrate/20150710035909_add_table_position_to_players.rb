class AddTablePositionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :table_position, :integer
  end
end
