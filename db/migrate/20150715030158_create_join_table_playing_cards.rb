class CreateJoinTablePlayingCards < ActiveRecord::Migration
  def change
    create_table :playing_cards, id: false do |t|
      t.integer :card_id
      t.integer :card_collection_id
    end
  end
end
