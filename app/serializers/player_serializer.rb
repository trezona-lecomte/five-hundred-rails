class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :handle

  has_one :user
  has_many :cards
end
