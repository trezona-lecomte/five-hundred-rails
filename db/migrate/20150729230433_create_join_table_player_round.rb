class CreateJoinTablePlayerRound < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.references :player, index: true, foreign_key: true
      t.references :round,  index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :hands, [:player_id, :round_id]
  end
end
