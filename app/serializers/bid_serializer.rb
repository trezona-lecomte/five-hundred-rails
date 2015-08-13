class BidSerializer < ActiveModel::Serializer
  attributes :number_of_tricks, :suit, :player

  def player
    Player.find(object.player_id).handle
  end
end
