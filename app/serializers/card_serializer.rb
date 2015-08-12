class CardSerializer < ActiveModel::Serializer
  attributes :id, :rank, :suit, :trick_id
end
