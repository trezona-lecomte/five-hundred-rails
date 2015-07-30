class CardSerializer < ActiveModel::Serializer
  attributes :id, :rank, :suit

  belongs_to :hand
  belongs_to :trick
end
