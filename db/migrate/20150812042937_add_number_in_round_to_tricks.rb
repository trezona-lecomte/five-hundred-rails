class AddNumberInRoundToTricks < ActiveRecord::Migration
  def change
    add_column :tricks, :number_in_round, :integer
  end
end
