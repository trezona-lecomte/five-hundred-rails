class AddNumberInTrickToCards < ActiveRecord::Migration
  def change
    add_column :cards, :number_in_trick, :integer
  end
end
