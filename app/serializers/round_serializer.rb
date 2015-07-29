class RoundSerializer < ActiveModel::Serializer
  attributes :id, :tricks#, :cards

  has_many :tricks
end
