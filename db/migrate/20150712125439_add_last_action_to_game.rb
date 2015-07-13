class AddLastActionToGame < ActiveRecord::Migration
  def change
    add_column :games, :last_action, :string
  end
end
