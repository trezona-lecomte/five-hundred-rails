class AddTrickRefToPlayingCards < ActiveRecord::Migration
  def change
    add_reference :playing_cards, :trick, index: true, foreign_key: true
  end
end
