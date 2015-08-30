class AvailableBidSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :number_of_tricks, :suit
end
