class RoundSerializer < ActiveModel::Serializer
#  embed :ids
  attributes :id, :path

  has_many :cards

  def cards
    object.cards.where(player: Player.first)
  end

  def path
    round_path(object)
  end
end
