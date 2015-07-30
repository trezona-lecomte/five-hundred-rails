class DealCards
  attr_reader :errors

  def initialize(game, round)
    @game = game
    @round = round
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
    deck = fresh_deck

    deal_to_players(deck)

    deal_kitty(deck)
  end

  def deal_to_players(deck)
    @game.players.each do |player|
      deck.pop(10).each do |card|
        player.cards << card

        unless card.save
          add_error("unable to deal card: #{card.rank} of #{card.suit} to player #{player.handle}")
        end
      end
    end
  end

  def deal_kitty(deck)
    deck.each do |card|
      @round.cards << card

      unless card.save
        add_error("unable to deal card: #{card.rank} of #{card.suit} to kitty")
      end
    end
  end

  def fresh_deck
    cards = []
    Card.ranks.keys.product(Card.suits.keys) do |rank, suit|
      unless suit == "no_suit" ||
             rank == "joker" ||
             ((suit == "spades" || suit == "clubs") && rank == "4")
        cards << Card.new(rank: rank, suit: suit, round: @round)
      end
    end

    cards << Card.new(rank: "joker", suit: "no_suit", round: @round)
    cards.shuffle!
  end

  def success?
    @round.errors.empty?
  end

  def add_error(message)
    @errors << message
  end
end
