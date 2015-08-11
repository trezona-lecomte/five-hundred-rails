class AddPositionInTrickToCards < ActiveRecord::Migration
  def change
    add_column :cards, :position_in_trick, :integer
  end
end
