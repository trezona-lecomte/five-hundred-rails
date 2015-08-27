class BidderTurnValidator < SimpleDelegator
  include ActiveModel::Validations

  validate :player_is_next_to_bid

  private

  def player_is_next_to_bid
    unless this_players_turn?
      errors.add(:base, "it's not your turn to bid")
    end
  end

  def this_players_turn?
    if round_is_awaiting_first_bid?
      player_is_first_to_bid_for_this_round?
    else
      player_is_next_in_order?
    end
  end

  def round_is_awaiting_first_bid?
    round.bids.none?
  end

  def player_is_first_to_bid_for_this_round?
    player.order_in_game == round.order_in_game % round.game.players.length
  end

  def player_is_next_in_order?
    players = rotate_to_next_non_passing_player(players_in_order_for_round)

    player == players.first
  end

  def players_in_order_for_round
    players = round.game.players.to_a.dup
    players.rotate!(round.order_in_game % players.length)
  end

  def rotate_to_next_non_passing_player(players)
    round.bids.each do |bid|
      if bid.pass?
        players.shift
      else
        players.rotate!
      end
    end

    players
  end
end
