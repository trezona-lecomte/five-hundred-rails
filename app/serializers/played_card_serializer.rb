class PlayedCardSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :rank, :suit, :order_in_trick, :played_by

  def played_by
    object.player.user.username
  end
end
