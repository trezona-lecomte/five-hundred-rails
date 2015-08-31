class CardSerializer < ActiveModel::Serializer
  # TODO: try preloading instead of caching - no more than 1 SQL statement per table per request (in rails s)
  attributes :id, :rank, :suit, :trick_id, :player_id
end
