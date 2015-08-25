class ScoreRound
  include ActiveModel::Validations

  attr_reader :round, :game, :players, :tricks

  validate :round_has_finished

  def initialize(round)
    @round   = round
    @game    = round.game
    @players = game.players
    @tricks  = round.tricks
  end

  def call
    round.with_lock do
      valid? && score_round!
    end
  end

  private

  def round_has_finished
    errors.add(:base, "this round can't be scored until it has finished") if !round.finished?
  end

  def score_round!
    highest_bid = round.highest_bid

    attack = AttackScore.new(attempted_number_of_tricks: highest_bid.number_of_tricks,
                             number_of_tricks_won: tricks_for(attacking_players).size,
                             attempted_suit: highest_bid.suit)

    defense = DefenseScore.new(number_of_tricks_won: tricks_for(defending_players).size)

    set_scores!(attack_score: attack.score, defense_score: defense.score)
  end

  def set_scores!(attack_score:, defense_score:)
    if attacking_players.first.order_in_game.odd?
      round.odd_players_score = attack_score
      round.even_players_score = defense_score
    else
      round.odd_players_score = defense_score
      round.even_players_score = attack_score
    end

    round.save!
  end

  def tricks_for(players)
    tricks.select { |trick| players.include?(trick.cards.highest.player) }
  end

  def attacking_players
    if bid_winning_player.order_in_game.even?
      players.select { |player| player.order_in_game.even? }
    else
      players.select { |player| player.order_in_game.odd? }
    end
  end

  def defending_players
    game.players - attacking_players
  end

  def bid_winning_player
    players.detect { |player| player == round.highest_bid.player }
  end
end
