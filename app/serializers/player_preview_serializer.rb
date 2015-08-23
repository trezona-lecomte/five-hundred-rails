class PlayerPreviewSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :handle, :order_in_game
end
