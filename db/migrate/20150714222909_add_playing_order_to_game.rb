class AddPlayingOrderToGame < ActiveRecord::Migration
  def change
    add_column :games, :playing_order, :text
  end
end
