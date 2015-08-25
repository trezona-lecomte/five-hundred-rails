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
      players = round.game.players.to_a.dup
      players.rotate!(round.order_in_game % players.length)

      round.bids.each do |bid|
        if bid.pass?
          players.shift
        else
          players.rotate!
        end
      end

      player == players.first
    end
  end

  def round_is_awaiting_first_bid?(round)
    round.bids.none?
  end

  def player_is_first_to_bid_for_this_round?(round, player)
    player.order_in_game == round.order_in_game % round.game.players.length
  end
end
