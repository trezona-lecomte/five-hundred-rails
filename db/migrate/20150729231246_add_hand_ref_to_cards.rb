class AddHandRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :hand, index: true, foreign_key: true
  end
end
