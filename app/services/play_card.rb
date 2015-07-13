class PlayCard
  def call(card:, trick:)
    tricks_in_round = Trick.includes(:cards).where(round: trick.round)

    if trick.cards.empty?
      if tricks_in_round.count == 1

        # hands.first # TODO actually needs to be the hand belonging to the player who won the bid
      else
        # previous_trick = tricks_in_round.last(2).first
        # previous_trick.winning_card.card_collection
      end
    elsif trick.won?
      card.errors[:base] << "This card can't be "
    else
      # hands[trick.cards.count]
    end


      trick.update!(cards: trick.cards << card)

  end
end


  def active_hand
    loaded_tricks = Trick.includes(:cards).where(round: self)

    return unless trick = loaded_tricks.last

    if trick.cards.empty?
      if loaded_tricks.count == 1
        hands.first # TODO actually needs to be the hand belonging to the player who won the bid
      else
        previous_trick = loaded_tricks.last(2).first
        previous_trick.winning_card.card_collection
      end
    elsif trick.won?
      self.errors[:tricks] << "The last trick has finished"
    else
      hands[trick.cards.count]
    end
  end