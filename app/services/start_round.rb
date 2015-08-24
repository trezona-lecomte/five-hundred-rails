# TODO apply AM validations pattern to all other services.
class StartRound
  include ActiveModel::Validations
  attr_reader :round

  validate :round_can_be_started

  def initialize(game)
    @game = game
    @round = nil
  end

  def call
    @game.with_lock do

      if valid?
        create_round
        create_tricks!
        deal_cards
      end
    end
  end

  private

  def round_can_be_started
    errors.add(:base, "rounds can't be started on games with unfinished rounds") if rounds_in_progress?
  end

  def rounds_in_progress?
    @game.rounds.any? { |round| !round.finished? }
  end

  # TODO: check if scores are specified anywhere else for round.
  def create_round
    @round = @game.rounds.create!(order_in_game: @game.rounds.count)
  end

  def create_tricks!
    Round::NUMBER_OF_TRICKS.times do |n|
      @round.tricks.create!(order_in_round: n)
    end
  end

  def deal_cards
    deck = BuildDeck.new.call
    DealCards.new(@round, deck).call
  end
end
