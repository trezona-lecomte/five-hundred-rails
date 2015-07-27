class ActionSerializer < ActiveModel::Serializer
  attributes :id, :round_id, :player_id, :card_id
end
