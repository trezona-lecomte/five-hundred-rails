class AddPassFlagToBids < ActiveRecord::Migration
  def change
    add_column :bids, :pass, :boolean, default: false, null: false
  end
end
