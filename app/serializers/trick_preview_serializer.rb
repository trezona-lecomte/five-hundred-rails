class TrickPreviewSerializer < ActiveModel::Serializer
  attributes :id, :path, :order_in_round, :status

  def path
    trick_path(object)
  end

  def status
    if object.active?
      "unfinished"
    else
      "finished"
    end
  end
end
