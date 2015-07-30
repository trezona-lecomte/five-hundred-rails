class RoundSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :game
  has_many :tricks
  has_many :cards
end
