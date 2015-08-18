class TrickSerializer < ActiveModel::Serializer
  attributes :id, :number_in_round, :winning_card

  has_many :cards, serializer: PlayedCardSerializer

  def winning_card
    cards = object.cards
    object.cards.highest unless object.cards.none?
  end
end
