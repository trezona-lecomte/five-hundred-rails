class RoundSerializer < ActiveModel::Serializer
  attributes :id, :tricks

  #has_many :tricks
end
