class CardSerializer < ActiveModel::Serializer
  # TODO: try preloading instead of caching - no more than 1 SQL statement per table per request (in rails s)
  cached
  delegate :cache_key, to: :object

  attributes :id, :rank, :suit, :trick_id, :player_id
end
