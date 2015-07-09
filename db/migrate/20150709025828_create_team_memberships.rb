class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_join_table :players, :teams, table_name: :team_memberships
  end
end
