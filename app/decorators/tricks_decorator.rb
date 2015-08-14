class TricksDecorator < SimpleDelegator
  def last_played_card
    cards.max_by { |card| card.number_in_trick }
  end

  def winning_card
    # TODO need to account for suit, trumps etc
    cards.max_by { |card| card.rank }
  end
end
