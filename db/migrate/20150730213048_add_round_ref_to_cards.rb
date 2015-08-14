class AddRoundRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :round, foreign_key: true
  end
end
