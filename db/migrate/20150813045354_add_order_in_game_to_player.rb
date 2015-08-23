class AddOrderInGameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :order_in_game, :integer
  end
end
