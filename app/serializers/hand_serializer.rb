class HandSerializer < ActiveModel::Serializer
  attributes :id, :player, :cards

  belongs_to :player
  belongs_to :round
  has_many :cards
end
