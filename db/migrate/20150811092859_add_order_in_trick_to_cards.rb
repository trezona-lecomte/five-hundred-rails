class AddOrderInTrickToCards < ActiveRecord::Migration
  def change
    add_column :cards, :order_in_trick, :integer
  end
end
