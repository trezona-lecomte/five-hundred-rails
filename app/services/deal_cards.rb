class DealCards
  def initialize(game, round)
    @game = game
    @round = round
  end

  def call
    @round.with_lock do
      deal_cards if cards_can_be_dealt
    end

    success?
  end

  private

  def cards_can_be_dealt
    true
  end

  def deal_cards
    deck = fresh_deck

    @game.players.each do |player|
      hand = player.hands.create!(round: @round)
      hand.cards << deck.pop(10)

      unless hand.save
        @round.errors.add(:base, "unable to deal cards to #{player.handle}")
      end
    end

    unless @round.save
      @round.errors.add(:base, "unable to deal cards")
    end
  end

  def fresh_deck
    cards = []
    Card.ranks.keys.product(Card.suits.keys) do |rank, suit|
      unless suit == "no_suit" ||
             rank == "joker" ||
             ((suit == "spades" || suit == "clubs") && rank == "4")
        cards << Card.new(rank: rank, suit: suit)
      end
    end

    cards << Card.new(rank: "joker", suit: "no_suit")

    cards
  end

  def success?
    @round.errors.empty?
  end
end
