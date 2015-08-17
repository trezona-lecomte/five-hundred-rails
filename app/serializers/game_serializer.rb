class GameSerializer < ActiveModel::Serializer
  attributes :id,
             :path,
             :stage,
             :odd_team_score,
             :even_team_score

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
end
