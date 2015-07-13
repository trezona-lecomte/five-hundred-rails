class AddRoundRefToActions < ActiveRecord::Migration
  def change
      add_reference :actions, :round, index: true, foreign_key: true
  end
end
