class BidderIsNextInOrderValidator < ActiveModel::Validator
  def validate(bid)
    unless this_players_turn?(bid.round, bid.player)
      bid.errors.add(:base, "it's not your turn to bid")
    end
  end

  private

  def this_players_turn?(round, player)
    if round.has_no_bids_yet?
      player_is_first_in_order_for_this_round?(round, player)
    else
      player_is_next_in_order?(round, player)
    end
  end

  def player_is_first_in_order_for_this_round?(round, player)
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
    round.bids.select(&:persisted?).each do |bid|
      if bid.pass?
        players.shift
      else
        players.rotate!
      end
    end

    players
  end
end
