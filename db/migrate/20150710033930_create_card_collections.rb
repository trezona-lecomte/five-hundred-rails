class CreateCardCollections < ActiveRecord::Migration
  def change
    create_table :card_collections do |t|
      t.references :player, index: true, foreign_key: true
    end
  end
end
