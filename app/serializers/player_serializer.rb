class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :handle, :number_in_game

  has_one :user
  has_many :cards
end
