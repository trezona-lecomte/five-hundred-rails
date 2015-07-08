class CreateTricks < ActiveRecord::Migration
  def change
    create_table :tricks do |t|
      t.timestamps null: false
    end
  end
end
