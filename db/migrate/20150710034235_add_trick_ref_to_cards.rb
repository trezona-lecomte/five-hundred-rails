class AddTrickRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :trick, index: true, foreign_key: true
  end
end
