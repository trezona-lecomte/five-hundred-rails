class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :game
  belongs_to :player

  validates_uniqueness_of :player, scope: :team
  validates_uniqueness_of :player, scope: :game
end
