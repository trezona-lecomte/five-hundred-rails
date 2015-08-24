class AddOrderInGameToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :order_in_game, :integer, null: false
  end
end
