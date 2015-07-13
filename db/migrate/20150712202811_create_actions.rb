class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.references :player, index: true, foreign_key: true
      t.string :action_type
      t.string :action_value
    end
  end
end
