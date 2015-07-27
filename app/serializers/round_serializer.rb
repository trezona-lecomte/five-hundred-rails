class RoundSerializer < ActiveModel::Serializer
  attributes :id

  has_many :actions
end
