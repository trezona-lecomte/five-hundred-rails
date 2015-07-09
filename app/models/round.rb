class Round < ActiveRecord::Base
  belongs_to :game
  has_many :tricks
  has_many :hands, -> { where(player_id: !nil) }, class_name: "CardCollection"
  has_one  :kitty, -> { where(player_id:  nil) }, class_name: "CardCollection"
end