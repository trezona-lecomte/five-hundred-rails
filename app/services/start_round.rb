class StartRound
  include ActiveModel::Validations

  attr_reader :game, :round

  validate :round_can_be_started

  def initialize(game:)
    @game = game
    @round = nil
  end

  def call
    game.with_lock do
      # TODO when an object is calling valid on itself when there is no user input this is too defensive
      # TODO try pulling call up to the caller (controller)
      if valid?
        create_round!
        create_tricks!
        deal_cards!
      end
    end
  end

  private

  def round_can_be_started
    errors.add(:base, "there are active rounds on this game") if active_rounds?
  end

  def active_rounds?
    game.rounds.none?(&:finished?)
  end

  def create_round!
    @round = game.rounds.create!(order_in_game: game.rounds.count)
  end

  def create_tricks!
    Round::NUMBER_OF_TRICKS.times do |trick_number|
      round.tricks.create!(order_in_round: trick_number)
    end
  end

  def deal_cards!
    deck = BuildDeck.new.call
    DealCards.new(round, deck).call
  end
end
