class RoundSerializer < ActiveModel::Serializer
  attributes :id,
             :order_in_game,
             :stage,
             :odd_players_score,
             :even_players_score

  has_one  :game,           embed: :id
  #has_many :available_bids, serializer: AvailableBidSerializer
  has_many :tricks,         embed: :ids
  has_many :bids,           key: :placed_bids
  has_many :cards,          key: :current_player_cards

  def stage
    puts "Entering: stage"
    if object.in_bidding_stage?
      "bidding"
    elsif object.finished?
      "finished"
    else
      "playing"
    end
  end

  def cards
    puts "Entering: cards"
    player = object.game.players.where(user: current_user)

    object.cards.unplayed.where(player: player)
  end
end
