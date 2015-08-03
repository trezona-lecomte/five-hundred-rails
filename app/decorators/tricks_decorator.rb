class TricksDecorator < SimpleDelegator
  def winning_card
    cards.max_by { |card| card.rank }
  end
end
