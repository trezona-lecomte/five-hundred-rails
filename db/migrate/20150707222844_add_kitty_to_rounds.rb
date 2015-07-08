class AddKittyToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :kitty, :text
  end
end
