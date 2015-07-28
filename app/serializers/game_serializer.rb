class GameSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :url

  has_many :players
  has_many :rounds

  def url
    game_path(object)
  end
end
