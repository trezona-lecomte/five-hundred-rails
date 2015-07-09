class AddGameRefToTeamMemberships < ActiveRecord::Migration
  def change
    add_reference :team_memberships, :game, index: true, foreign_key: true
  end
end
