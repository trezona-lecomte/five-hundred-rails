class GameSerializer < ActiveModel::Serializer
  attributes :id, :path

  has_many :players
  has_many :rounds, serializer: RoundPreviewSerializer

  def path
    game_path(object)
  end
end
