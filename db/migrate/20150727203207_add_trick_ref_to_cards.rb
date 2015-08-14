class AddTrickRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :trick, foreign_key: true
  end
end
