class CardSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :rank, :suit, :trick_id, :player_id
end
