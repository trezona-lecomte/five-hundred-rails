class StartRound
  include ActiveModel::Validations

  attr_reader :game, :round

  validate :all_rounds_in_game_finished
  validate :enough_players_in_game

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

  def all_rounds_in_game_finished
    if any_active_rounds_on_game?
      errors.add(:base, "all rounds in this game must be finished before starting a new one")
    end
  end

  def enough_players_in_game
    if players_less_than_minimum?
      errors.add(:base, "there are not enough players in the game to start")
    end
  end

  def any_active_rounds_on_game?
    game.rounds.present? && !game.rounds.all?(&:finished?)
  end

  def players_less_than_minimum?
    game.players.count < Game::MIN_PLAYERS
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
