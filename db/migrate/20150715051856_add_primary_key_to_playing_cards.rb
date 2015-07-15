class AddPrimaryKeyToPlayingCards < ActiveRecord::Migration
  def change
    add_column :playing_cards, :id, :primary_key
  end
end
