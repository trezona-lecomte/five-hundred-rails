class RoundsDecorator < SimpleDelegator
  def bidding?
    # TODO: need to deal with the situation where everyone passes
    bids.passes.group_by { |pass| pass.player }.count < (game.players.count - 1)
  end

  def playing?
    active_trick
  end

  def finished?
    !active_trick
  end

  def active_trick
    unless bidding?
      tricks.includes(:cards).order(:number_in_round).detect { |trick| trick.cards.count < 4 }
    end
  end

  def previous_trick_winner
    trick = previous_trick
    if finished?
      TricksDecorator.new(tricks.order(number_in_round: :asc).last).winning_card.player
    elsif trick && trick.cards.present? && playing?
      TricksDecorator.new(trick).winning_card.player
    end
  end

  def previous_trick
    if current_trick = active_trick
      tricks.find_by(number_in_round: current_trick.number_in_round - 1)
    end
  end

  def available_bids
    if bidding?
      if winning_bid
        pass_bid + bids_above_highest_bid(non_pass_bids, winning_bid)
      else
        pass_bid + non_pass_bids
      end
    else
      []
    end
  end

  def winning_bid
    bids.in_ranked_order.first
  end

  def kitty
    cards.includes(:player).where("player_id is null")
  end

  def unplayed_cards(player)
    cards.where(player: player).where("trick_id": nil)
  end

  private

  def bids_above_highest_bid(non_pass_bids, highest_bid)
    highest_tricks = highest_bid.number_of_tricks
    highest_suit = highest_bid.suit

    non_pass_bids.select do |number_of_tricks, suit|
       number_of_tricks  > highest_tricks ||
      (number_of_tricks == highest_tricks && Bid.suits[suit] > Bid.suits[highest_suit])
    end
  end

  def non_pass_bids
    (6..10).to_a.product(Bid.suits.keys)
  end

  def pass_bid
    [[0, "no_suit"]]
  end
end
