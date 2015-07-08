class AddRoundRefToCardCollections < ActiveRecord::Migration
  def change
    add_reference :card_collections, :round, index: true, foreign_key: true
  end
end
