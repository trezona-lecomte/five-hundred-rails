class DealCards
  attr_reader :errors

  def initialize(game, round, deck)
    @game = game
    @round = round
    @deck = deck
    @errors = []
  end

  def call
    @round.with_lock do
      deal_cards if cards_can_be_dealt
    end

    success?
  end

  private

  def cards_can_be_dealt
    # TODO: implement actual validations for when cards can be dealt
    true
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
