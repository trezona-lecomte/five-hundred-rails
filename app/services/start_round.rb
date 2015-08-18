class StartRound
  attr_reader :round

  def initialize(game)
    @game = game
    @round = nil
  end

  def call
    @game.with_lock do
      if no_unfinished_rounds?
        create_round
        create_tricks
        deal_cards
      else
        false
      end
    end
  end

  private

  def no_unfinished_rounds?
    @game.rounds.all? { |round| RoundsDecorator.new(round).finished? }
  end

  def create_round
    @round = @game.rounds.create!(number_in_game: @game.rounds.count + 1)
  end

  def create_tricks
    Round::NUMBER_OF_TRICKS.times do |n|
      @round.tricks.create!(number_in_round: n + 1)
    end
  end

  def deal_cards
    deck = BuildDeck.new.call
    dealer = DealCards.new(@round, deck)
    dealer.call
  end
end
