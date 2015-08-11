class RoundPreviewSerializer < ActiveModel::Serializer
  attributes :id, :path

  def path
    round_path(object)
  end
end
