class AddPlayingOrderToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :playing_order, :text
  end
end
