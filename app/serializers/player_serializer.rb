class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :handle, :order_in_game

  has_one :user
end
