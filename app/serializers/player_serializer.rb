class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :path

  has_one :user

  def path
    player_path(object)
  end
end
