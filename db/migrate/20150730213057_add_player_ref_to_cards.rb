class AddPlayerRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :player, index: true, foreign_key: true
  end
end
