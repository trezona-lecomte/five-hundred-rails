class RoundPreviewSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :path

  def path
    round_path(object)
  end
end
