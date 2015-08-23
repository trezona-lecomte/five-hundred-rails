class GameSerializer < ActiveModel::Serializer
  attributes :id,
             :path,
             :stage,
             :odd_players_score,
             :even_players_score

  has_one  :active_round, serializer: RoundPreviewSerializer
  has_many :players
  has_many :rounds, serializer: RoundPreviewSerializer

  def path
    game_path(object)
  end

  def stage
    if object.finished?
      "finished"
    else
      "in progress"
    end
  end

  def active_round
    if object.finished?
      nil
    else
      object.rounds.max_by { |round| round.order_in_game }
    end
  end
end
