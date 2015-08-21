class AddScoresToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :odd_players_score, :integer
    add_column :rounds, :even_players_score, :integer
  end
end
