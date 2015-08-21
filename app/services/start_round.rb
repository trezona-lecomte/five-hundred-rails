class StartRound
  attr_reader :round, :errors

  def initialize(game)
    @game = game
    @round = nil
    @errors = []
  end

  def call
    @game.with_lock do
      validate_round_can_be_started

      if errors.none?
        create_round
        create_tricks!
        deal_cards
      end
    end
  end

  private

  def validate_round_can_be_started
    unless all_existing_rounds_finished?
      add_error("rounds can't be started on games with unfinished rounds")
    end
  end

  def all_existing_rounds_finished?
    @game.rounds.all?(&:finished?)
  end

  def create_round
    # TODO rename number_in_game on Round
    @round = @game.rounds.create!(number_in_game: @game.rounds.count + 1,
                                  odd_players_score: 0,
                                  even_players_score: 0)
  end

  def create_tricks!
    Round::NUMBER_OF_TRICKS.times do |n|
      @round.tricks.create!(number_in_round: n + 1)
    end
  end

  def deal_cards
    deck = BuildDeck.new.call
    dealer = DealCards.new(@round, deck)
    dealer.call
  end

  def add_error(message)
    @errors << message
  end
end
