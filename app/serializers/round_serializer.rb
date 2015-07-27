class RoundSerializer < ActiveModel::Serializer
  attributes :id

  has_many :tricks
end
