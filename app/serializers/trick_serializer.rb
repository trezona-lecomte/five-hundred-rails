class TrickSerializer < ActiveModel::Serializer
  attributes :id, :round_id, :cards

  has_many :cards
end
