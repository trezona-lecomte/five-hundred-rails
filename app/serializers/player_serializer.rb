class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :game_id, :handle, :cards
  has_many :cards
end
