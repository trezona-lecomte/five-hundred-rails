class AddCardsCountToTricks < ActiveRecord::Migration
  def self.up
    add_column :tricks, :cards_count, :integer, :default => 0

    Trick.reset_column_information
    Trick.all.each do |t|
      t.update_attribute :cards_count, t.cards.length
    end
  end

  def self.down
    remove_column :tricks, :cards_count
  end
end
