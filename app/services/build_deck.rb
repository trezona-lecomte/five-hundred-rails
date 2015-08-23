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
    standard_ranks.product(standard_suits).each do |rank, suit|
      @deck << Card.new(rank: rank, suit: suit)
    end

    @deck += red_fours
    @deck << joker
  end

  def standard_ranks
    Card.ranks.select { |_, rank| rank.between?(5, 17) && !rank.between?(11, 13) }
      .keys
  end

  def standard_suits
    Card.suits.select { |suit, _| suit != Suits::NO_SUIT }
      .keys
  end

  def red_fours
    [Card.new(rank: "4", suit: Suits::HEARTS),
     Card.new(rank: "4", suit: Suits::DIAMONDS)]
  end

  def joker
    Card.new(rank: "joker", suit: "no_suit")
  end
end
