class AddRoundRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :round, index: true, foreign_key: true
  end
end
