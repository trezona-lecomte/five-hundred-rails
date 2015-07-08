class AddRoundRefToTricks < ActiveRecord::Migration
  def change
    add_reference :tricks, :round, index: true, foreign_key: true
  end
end
