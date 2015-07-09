class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
