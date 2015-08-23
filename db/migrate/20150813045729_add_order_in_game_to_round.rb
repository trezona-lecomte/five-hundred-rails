class AddOrderInGameToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :order_in_game, :integer
  end
end
