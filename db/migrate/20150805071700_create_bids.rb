class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :round, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.integer :number_of_tricks
      t.integer :suit

      t.timestamps null: false
    end
  end
end
