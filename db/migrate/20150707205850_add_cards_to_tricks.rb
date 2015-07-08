class AddCardsToTricks < ActiveRecord::Migration
  def change
    add_column :tricks, :cards, :text
  end
end
