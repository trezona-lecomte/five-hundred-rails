class RoundSerializer < ActiveModel::Serializer
  attributes :id, :path

  has_many :tricks
  has_many :cards, key: :player_cards

  def path
    round_path(object)
  end

  def cards
    player = object.game.players.where(user: current_user)
    object.cards.where(player: player)
  end
end
