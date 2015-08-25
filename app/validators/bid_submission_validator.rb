class BidSubmissionValidator < ActiveModel::Validator
  def validate(submit_bid)
    if !bidding_is_open?(submit_bid.round)
      submit_bid.errors.add(:base, "bidding for this round has finished")
    elsif !this_players_turn?(submit_bid.round, submit_bid.player)
      submit_bid.errors.add(:base, "it's not your turn to bid")
    elsif !bid_is_higher_than_previous_or_pass?(submit_bid.round, submit_bid.number_of_tricks, submit_bid.suit)
      submit_bid.errors.add(:base, "your bid must be higher than the previous bid")
    end
  end

  private

  def bidding_is_open?(round)
    round.in_bidding_stage?
  end

  def this_players_turn?(round, player)
    if round_is_awaiting_first_bid?(round)
      player_is_first_to_bid_for_this_round?(round, player)
    else
      # TODO use dup instead of slice
      players = round.game.players.to_a.dup
      players.rotate!(round.order_in_game % players.length)

      round.bids.each do |bid|
        raise Error if bid.player.id != players.first.id

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

  # TODO: need to put this on bid...
  def bid_is_higher_than_previous_or_pass?(round, number_of_tricks, suit)
    highest_bid = round.bids.last

    !highest_bid ||
    number_of_tricks == Bid::PASS_TRICKS ||
    number_of_tricks > highest_bid.number_of_tricks ||
    (number_of_tricks == highest_bid.number_of_tricks && suit > Bid.suits[highest_bid.suit])
  end
end
