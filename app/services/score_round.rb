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
    score = Score.new(number_of_tricks: attempted_number_of_tricks,
                      suit: attempted_suit)
    if successful_attack?
      attacker_score = score.for_successful_attack
    else
      attacker_score = score.for_failed_attack
    end

    defender_score = Score.new(number_of_tricks: tricks_for(defending_players).size).for_defense

    set_scores!(attacker_score, defender_score)
  end

  def set_scores!(attack_score, defense_score)
    if attacking_players.first.order_in_game.odd?
      round.odd_players_score = attack_score
      round.even_players_score = defense_score
    else
      round.odd_players_score = defense_score
      round.even_players_score = attack_score
    end

    round.save!
  end

  def successful_attack?
    attacker_tricks = tricks_for(attacking_players)

    attacker_tricks.count >= attempted_number_of_tricks
  end

  def tricks_for(team_members)
    tricks.select { |trick| team_members.include?(trick.cards.highest.player) }
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
    players.find { |player| player == round.highest_bid.player }
  end

  def attempted_number_of_tricks
    round.highest_bid.number_of_tricks
  end

  def attempted_suit
    round.highest_bid.suit
  end
end
