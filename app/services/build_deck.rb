class BuildDeck
  attr_reader :deck

  def initialize
    @deck = []
  end

  def call
    standard_deck.shuffle!
  end

  private

  def standard_deck
    Card.ranks.select { |_, rank| rank.between?(5, 14) }.keys
      .product(Card.suits.select { |_, suit| suit != "no_suit" }.keys)
        .each do |rank, suit|
          @deck << Card.new(rank: rank, suit: suit)
      end

    @deck << Card.new(rank: "4", suit: "spades")
    @deck << Card.new(rank: "4", suit: "clubs")
    @deck << Card.new(rank: "joker", suit: "no_suit")
  end
end
