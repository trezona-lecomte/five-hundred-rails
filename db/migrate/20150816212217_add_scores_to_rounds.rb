class AddScoresToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :odd_players_score, :integer, null: false, default: 0
    add_column :rounds, :even_players_score, :integer, null: false, default: 0
  end
end
