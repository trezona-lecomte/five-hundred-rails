class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.references :round, index: true, foreign_key: true
      t.references :card, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
