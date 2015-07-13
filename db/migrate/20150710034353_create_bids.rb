class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :number
      t.string :suit
      t.references :player, index: true, foreign_key: true
      t.references :round, index: true, foreign_key: true
    end
  end
end
