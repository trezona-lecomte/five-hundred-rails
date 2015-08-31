class RoundSerializer < ActiveModel::Serializer
  attributes :id,
             :bids_path,
             :tricks_path,
             :cards_path,
             :order_in_game,
             :stage,
             :odd_players_score,
             :even_players_score

  has_one :game,    embed: :id
  has_many :tricks, embed: :ids

  def bids_path
    round_bids_path(object)
  end

  def tricks_path
    round_tricks_path(object)
  end

  def cards_path
    round_cards_path(object)
  end

  def stage
    if object.in_bidding_stage?
      "bidding"
    elsif object.finished?
      "finished"
    else
      "playing"
    end
  end

  def cards
    player = object.game.players.where(user: current_user)

    object.cards.unplayed.where(player: player)
  end
end
