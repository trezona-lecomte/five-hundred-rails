class AvailableBidSerializer < ActiveModel::Serializer
  attributes :pass, :number_of_tricks, :suit
end
