class Game < ActiveRecord::Base
  MAX_PLAYERS = 4

  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy

  def finished?
    odd_team_score.abs >= 500 || even_team_score.abs >= 500
  end

  # TODO players would be nicer than 'team'
  def odd_team_score
    rounds.where.not(odd_team_score: nil).to_a.sum(&:odd_team_score)
    # TODO try .sum without to_a & ampersand, rather than bringing objs into memory, do the sum in db.
  end

  def even_team_score
    rounds.where.not(even_team_score: nil).to_a.sum(&:even_team_score)
  end
end
