class Round < ActiveRecord::Base
  belongs_to :game
  has_many :tricks
  has_many :hands, class_name: "CardCollection"
  has_one :kitty, class_name: "CardCollection", foreign_key: "round_kitty_id"
end
