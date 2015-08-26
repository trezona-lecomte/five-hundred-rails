class BidderTurnValidator < ActiveModel::Validator
  def validate(submit_bid)
    unless this_players_turn?(submit_bid.round, submit_bid.player)
      submit_bid.errors.add(:base, "it's not your turn to bid")
    end
  end

  private

  def this_players_turn?(round, player)
    if round_is_awaiting_first_bid?(round)
      player_is_first_to_bid_for_this_round?(round, player)
    else
      player_is_next_in_order?(round, player)
    end
  end

  def round_is_awaiting_first_bid?(round)
    round.bids.none?
  end

  def player_is_first_to_bid_for_this_round?(round, player)
    player.order_in_game == round.order_in_game % round.game.players.length
  end

  def player_is_next_in_order?(round, player)
    players = rotate_to_next_non_passing_player(round, players_in_order_for_round(round))

    player == players.first
  end

  def players_in_order_for_round(round)
    players = round.game.players.to_a.dup
    players.rotate!(round.order_in_game % players.length)
  end

  def rotate_to_next_non_passing_player(round, players)
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
