class AddCardCollectionRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :card_collection, index: true, foreign_key: true
  end
end
