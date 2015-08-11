class PlayedCardSerializer < ActiveModel::Serializer
  attributes :rank, :suit, :position_in_trick, :played_by

  def played_by
    object.player.user.username
  end
end
