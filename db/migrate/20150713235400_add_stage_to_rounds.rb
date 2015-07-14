class AddStageToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :stage, :integer, default: 0
  end
end
