class TrickSerializer < ActiveModel::Serializer
  attributes :id, :number_in_round

  has_one :winning_card, embed: :id

  has_many :cards, serializer: PlayedCardSerializer

  def winning_card
    TricksDecorator.new(object).winning_card
  end
end
