class CardSerializer < ActiveModel::Serializer
  attributes :id, :rank, :suit

  belongs_to :round, :player
end
