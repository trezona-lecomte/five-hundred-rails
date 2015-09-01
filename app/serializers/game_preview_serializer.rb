class GamePreviewSerializer < ActiveModel::Serializer
  attributes :id, :path

  def path
    game_path(object)
  end
end
