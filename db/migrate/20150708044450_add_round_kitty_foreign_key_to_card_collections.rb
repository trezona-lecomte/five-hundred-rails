class AddRoundKittyForeignKeyToCardCollections < ActiveRecord::Migration
  def change
    add_column :card_collections, :round_kitty_id, :integer
    add_index :card_collections, :round_kitty_id
  end
end
