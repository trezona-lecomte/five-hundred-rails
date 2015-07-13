class CreateTricks < ActiveRecord::Migration
  def change
    create_table :tricks do |t|
    end

    add_reference :tricks, :round, index: true, foreign_key: true
  end
end
