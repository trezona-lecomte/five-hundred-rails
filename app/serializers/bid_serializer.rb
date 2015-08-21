class BidSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :number_of_tricks, :suit, :player

  def player
    Player.find(object.player_id).handle
  end
end
