class RoundsDecorator < SimpleDelegator
  def hands
    cards.includes(:player).where("player_id is not null").group_by { |card| card.player }
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
end
