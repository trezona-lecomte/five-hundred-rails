class DealCards
  attr_reader :errors

  def initialize(round, deck)
    @round = round
    @game = round.game
    @deck = deck
  end

  def call
    @round.with_lock do
      deal_cards if cards_can_be_dealt
    end

    success?
  end

  private

  def cards_can_be_dealt
    @round.cards.count == 0
  end

  def deal_cards
    deal_hands

    deal_kitty
  end

  def deal_hands
    @game.players.each do |player|
      @deck.pop(10).each do |card|
        card.round = @round

        player.cards << card

        # TODO for the whole service, just call save.bang! - don't worry about errors
        unless card.save
          add_error("unable to deal card: #{card.rank} of #{card.suit} to #{player.handle}")
        end
      end
    end
  end

  def deal_kitty
    @deck.each do |card|
      card.round = @round

      unless card.save
        add_error("unable to deal card: #{card.rank} of #{card.suit} to the kitty")
      end
    end
  end

  def success?
    @round.errors.empty?
  end

  def add_error(message)
    @errors << message
  end
end
