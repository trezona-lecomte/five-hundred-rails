class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :suit
      t.integer :rank
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
