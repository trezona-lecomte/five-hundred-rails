class GameSerializer < ActiveModel::Serializer
  attributes :id, :path

  has_many :rounds, :players

  def path
    game_path(object)
  end
end
