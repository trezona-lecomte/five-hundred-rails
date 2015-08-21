class PlayerPreviewSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :handle, :number_in_game
end
