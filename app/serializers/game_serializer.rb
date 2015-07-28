class GameSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :path

  #has_many :players

  def path
    game_path(object)
  end
end
