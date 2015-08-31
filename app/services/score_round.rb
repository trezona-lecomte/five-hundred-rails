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
    set_scores && round.save!
  end

  def set_scores
    if odd_team_attacked?
      round.odd_players_score  = attackers_score(round.highest_bid)
      round.even_players_score = defenders_score
    else
      round.odd_players_score  = defenders_score
      round.even_players_score = attackers_score(round.highest_bid)
    end
  end

  def attackers_score(highest_bid)
    AttackScore.new(
      attempted_suit:             highest_bid.suit,
      attempted_number_of_tricks: highest_bid.number_of_tricks,
      number_of_tricks_won:       tricks_for(attacking_players).size
    ).score
  end

  def defenders_score
    DefenseScore.new(
      number_of_tricks_won: tricks_for(defending_players).size
    ).score
  end

  def tricks_for(players)
    tricks.select { |trick| players.include?(trick.winning_player) }
  end

  def odd_team_attacked?
    attacking_players.first.order_in_game.odd?
  end

  def attacking_players
    if bid_winning_player.order_in_game.even?
      players.select { |player| player.order_in_game.even? }
    elsif bid_winning_player.order_in_game.odd?
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
