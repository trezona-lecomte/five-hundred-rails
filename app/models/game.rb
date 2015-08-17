class Game < ActiveRecord::Base
  MAX_PLAYERS = 4

  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy

  def finished?
    odd_team_score.abs >= 500 || even_team_score >= 500
  end

  def odd_team_score
    rounds.to_a.sum(&:odd_team_score)
  end

  def even_team_score
    rounds.to_a.sum(&:even_team_score)
  end
end
