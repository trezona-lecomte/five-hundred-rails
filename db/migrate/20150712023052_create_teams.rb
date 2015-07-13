class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :number
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :players, :team, index: true, foreign_key: true
  end
end
