class AddCardAndCardCollectionIndexToPlayingCards < ActiveRecord::Migration
  def change
    add_index :playing_cards, [:card_collection_id, :card_id], unique: true
  end
end
