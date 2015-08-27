class AddIndexOnRoundAndPassColumnsToBid < ActiveRecord::Migration
  def change
    add_index :bids, [:round_id, :pass]
  end
end
