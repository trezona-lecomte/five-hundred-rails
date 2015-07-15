class AddDeckTypeToGames < ActiveRecord::Migration
  def change
    add_column :games, :deck_type, :string
  end
end
