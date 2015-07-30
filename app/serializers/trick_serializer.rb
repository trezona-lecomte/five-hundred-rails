class TrickSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :round
  has_many :cards

  # def cards
  #   cards = []
  #   object.cards.each do |card|
  #     cards << { id: card.id, rank: card.rank, suit: card.suit }
  #   end
  # end
end
