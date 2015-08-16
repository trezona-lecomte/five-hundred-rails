class AddScoresToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :odd_team_score, :integer
    add_column :rounds, :even_team_score, :integer
  end
end
