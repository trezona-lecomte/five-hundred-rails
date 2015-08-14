class PlayedCardSerializer < ActiveModel::Serializer
  attributes :id, :rank, :suit, :number_in_trick, :played_by

  def played_by
    object.player.user.username
  end
end
