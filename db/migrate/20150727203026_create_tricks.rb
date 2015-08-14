class CreateTricks < ActiveRecord::Migration
  def change
    create_table :tricks do |t|
      t.references :round, foreign_key: true

      t.timestamps null: false
    end
  end
end
