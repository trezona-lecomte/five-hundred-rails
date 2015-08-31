class Game < ActiveRecord::Base
  MAX_PLAYERS  =   4
  MIN_PLAYERS  =   4
  HAND_SIZE    =  10
  TARGET_SCORE = 500

  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy

  def finished?
    odd_players_score.abs >= TARGET_SCORE || even_players_score.abs >= TARGET_SCORE
  end

  def active_round
    rounds.in_playing_order.last unless finished?
  end

  def odd_players_score
    rounds.sum(:odd_players_score)
  end

  def even_players_score
    rounds.sum(:even_players_score)
  end
end
