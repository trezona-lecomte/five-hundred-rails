class GameSerializer < ActiveModel::Serializer
  attributes :id
  has_many :players
  has_many :rounds
end
