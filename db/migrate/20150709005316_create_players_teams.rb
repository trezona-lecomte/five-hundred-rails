class CreatePlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams, id: false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :team, index: true
    end
  end
end
