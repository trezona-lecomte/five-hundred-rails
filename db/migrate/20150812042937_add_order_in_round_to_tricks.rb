class AddOrderInRoundToTricks < ActiveRecord::Migration
  def change
    add_column :tricks, :order_in_round, :integer
  end
end
