class TricksDecorator < SimpleDelegator
  def winning_card
    # TODO need to account for suit, trumps etc
    cards.max_by { |card| card.rank }
  end
end
