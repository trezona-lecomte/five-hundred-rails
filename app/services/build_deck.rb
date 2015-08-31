class BuildDeck
  include Ranks, Suits

  attr_reader :deck

  def call
    standard_deck.shuffle!
  end

  private

  def standard_deck
     base_deck + red_fours + [joker]
  end

  def base_deck
    standard_ranks.product(STANDARD_SUITS).map do |rank, suit|
      Card.new(rank: rank, suit: suit)
    end
  end

  def standard_ranks
    ALL_RANKS - [TWO, THREE, FOUR, ELEVEN, TWELVE, THIRTEEN, JOKER]
  end

  def red_fours
    [
      Card.new(rank: FOUR, suit: HEARTS),
      Card.new(rank: FOUR, suit: DIAMONDS)
    ]
  end

  def joker
    Card.new(rank: JOKER, suit: NO_SUIT)
  end
end
