class BuildDeck
  include Suits
  NUMBERS = (4..14).to_a

  def call
    cards = NUMBERS.product(ALL_SUITS.select { |suit| suit != NO_TRUMPS })
    cards << joker

    exclusions = [4].product([CLUBS, SPADES])

    (cards - exclusions).map { |number, suit| Card.new(number: number, suit: suit) }
  end

  private

  def joker
    [NUMBERS.max + 1, NO_TRUMPS]
  end
end
