class RoundsDecorator < SimpleDelegator
  def unplayed_cards(player)
    cards.where(player: player).where("trick_id": nil)
  end

  def kitty
    cards.includes(:player).where("player_id is null")
  end

  def passes
    bids.includes(:player).where(number_of_tricks: 0)
  end

  def winning_bid
    bids.includes(:player).order(number_of_tricks: :desc, suit: :desc).first
  end

  def stage
    if bidding?
      "bidding"
    elsif playing?
      "playing"
    end
  end

  def bidding?
    # TODO: need to deal with the situation where everyone passes
    passes.group_by { |pass| pass.player }.count < (game.players.count - 1)
  end

  def playing?
    !bidding? && active_trick
  end

  def available_bids
    if winning_bid
      pass_bid + bids_above_highest_bid(non_pass_bids, winning_bid)
    else
      pass_bid + non_pass_bids
    end
  end

  def active_trick
    tricks.includes(:cards).order(:number_in_round).detect { |trick| trick.cards.count < 4 }
  end

  def previous_trick
    active_trick_number = active_trick.number_in_round
    tricks.find_by(number_in_round: active_trick_number - 1)
  end

  def previous_trick_winner
    TricksDecorator.new(previous_trick).winning_card.player
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
