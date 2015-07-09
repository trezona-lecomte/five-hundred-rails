class Team < ActiveRecord::Base
  belongs_to :game
  has_many :team_memberships
  has_many :players, through: :team_memberships

  validates :players, length: { maximum: 2 }
end