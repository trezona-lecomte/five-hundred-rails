class AddIndexes < ActiveRecord::Migration
  def change
    add_index :cards,   [:trick_id, :player_id]
    add_index :players, [:game_id, :user_id]
    add_index :bids,    [:round_id, :number_of_tricks]
    add_index :tricks,  [:round_id, :number_in_round]
  end
end
