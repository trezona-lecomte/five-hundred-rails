class RoundPreviewSerializer < ActiveModel::Serializer
  attributes :id, :path, :stage

  def path
    round_path(object)
  end

  def stage
    if object.finished?
      "finished"
    else
      "in progress"
    end
  end
end
