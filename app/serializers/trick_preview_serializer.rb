class TrickPreviewSerializer < ActiveModel::Serializer
  attributes :id, :order_in_round, :status, :cards_count

  def status
    if object.active?
      "unfinished"
    else
      "finished"
    end
  end
end
