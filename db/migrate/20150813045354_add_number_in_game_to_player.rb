class AddNumberInGameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :number_in_game, :integer
  end
end
