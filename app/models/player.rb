class Player < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :hands, class_name: "CardCollection"
  validates :name, presence: true
end
