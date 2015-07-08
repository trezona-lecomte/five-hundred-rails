class AddCardsToHands < ActiveRecord::Migration
  def change
    add_column :hands, :cards, :text
  end
end
