class BuildDeck
  SUITS = %i(hearts diamonds clubs spades)
  NUMBERS = (4..14).to_a

  def call
    cards = NUMBERS.product(SUITS)
    cards << joker

    exclusions = [4].product([:clubs, :spades])

    (cards - exclusions).map { |number, suit| Card.new(number, suit) }
  end

  private

  def joker
    [NUMBERS.max + 1, :none]
  end
end
