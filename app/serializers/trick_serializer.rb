class TrickSerializer < ActiveModel::Serializer
  attributes :id, :order_in_round

  has_many :cards, each_serializer: PlayedCardSerializer
  has_one  :winning_card, embed: :id, serializer: PlayedCardSerializer

  def cards
    object.cards
  end

  def winning_card
    object.cards.highest unless object.cards.none?
  end
end
