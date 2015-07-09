class AddUniquenessAndIndexToTeamMemberships < ActiveRecord::Migration
  def change
    add_index :team_memberships, [:player_id, :team_id], unique: true
  end
end
