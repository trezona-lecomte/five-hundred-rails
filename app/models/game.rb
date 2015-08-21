class Game < ActiveRecord::Base
  MAX_PLAYERS = 4

  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy

  def finished?
    odd_players_score.abs >= 500 || even_players_score.abs >= 500
  end

  def active_round
    unless finished?
      rounds.in_playing_order.last
    end
  end

  def odd_players_score
    rounds.where.not(odd_players_score: nil).sum(:odd_players_score)
  end

  def even_players_score
    rounds.where.not(even_players_score: nil).sum(:even_players_score)
  end
end
