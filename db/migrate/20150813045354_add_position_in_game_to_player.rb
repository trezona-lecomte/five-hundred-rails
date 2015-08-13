class AddPositionInGameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :position_in_game, :integer
  end
end
