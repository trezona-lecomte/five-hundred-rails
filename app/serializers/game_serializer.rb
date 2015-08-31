class GameSerializer < ActiveModel::Serializer
  attributes :id,
             :stage,
             :odd_players_score,
             :even_players_score,
             :rounds_path,
             :players_path

  def stage
    if object.finished?
      "finished"
    else
      "in progress"
    end
  end

  def rounds_path
    game_rounds_path(object)
  end

  def players_path
    game_players_path(object)
  end
end
