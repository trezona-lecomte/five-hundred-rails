class BidSerializer < ActiveModel::Serializer
  attributes :pass, :number_of_tricks, :suit

  has_one :player, serializer: PlayerPreviewSerializer
end
