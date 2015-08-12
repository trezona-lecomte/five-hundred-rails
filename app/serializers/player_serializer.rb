class PlayerSerializer < ActiveModel::Serializer
  attributes :id

  has_one :user
  has_many :cards
end
