class RoundSerializer < ActiveModel::Serializer
  attributes :id, :path

  has_one :active_trick, serializer: TrickSerializer
  has_many :tricks, embed: :ids
  has_many :cards, key: :current_player_cards

  def path
    round_path(object)
  end

  def cards
    player = object.game.players.where(user: current_user)
    object.cards.where(player: player)
  end

  def active_trick
    object.active_trick
  end
end
