class BuildDeck
  attr_reader :deck

  # def initialize
  #   @deck = []
  # end

  def call
    standard_deck.shuffle!
  end

  private

  def standard_deck
    standard_ranks.product(standard_suits).map do |rank, suit|
      Card.new(rank: rank, suit: suit)
    end + red_fours + [joker]

    # @deck += red_fours
    # @deck << joker
  end

  # TODO should be using enum values for this filter (build an array of wanted cards & check inclusion)
  def standard_ranks
    Card.ranks.select { |_, rank| rank.between?(5, 17) && !rank.between?(11, 13) }
      .keys
  end

  def standard_suits
    Card.suits.keys - [Suits::NO_SUIT]
  end

  # TODO again (next two methods), use enum values
  def red_fours
    [
      Card.new(rank: "4", suit: Suits::HEARTS),
      Card.new(rank: "4", suit: Suits::DIAMONDS)
    ]
  end

  def joker
    Card.new(rank: "joker", suit: Suits::NO_SUIT)
  end
end
