class AddRoundRefToHands < ActiveRecord::Migration
  def change
    add_reference :hands, :round, index: true, foreign_key: true
  end
end
