class AddOrderInRoundToBids < ActiveRecord::Migration
  def change
    add_column :bids, :order_in_round, :integer
  end
end
