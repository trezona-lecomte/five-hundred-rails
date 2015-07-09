class Player < ActiveRecord::Base
  has_many :teams, through: :team_memberships
  has_many :hands, class_name: "CardCollection"
  validates :name, presence: true

end
