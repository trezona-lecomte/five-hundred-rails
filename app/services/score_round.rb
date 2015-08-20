class ScoreRound
  attr_reader :round, :game, :players, :tricks, :errors

  def initialize(round)
    @round   = RoundsDecorator.new(round)
    @game    = round.game
    @players = game.players
    @tricks  = round.tricks
    @errors  = []
  end

  def call
    round.with_lock do
      if round.finished?
        score_round

        unless round.save
          add_error("unable to save round")
        end
      else
        add_error("this round hasn't finished yet")
      end
    end

    errors.none?
  end

  private

  def score_round
    score = Score.new(number_of_tricks: attempted_number_of_tricks,
                      suit: attempted_suit)
    if successful_attack?
      attacker_score = score.for_successful_attack
    else
      attacker_score = score.for_failed_attack
    end

    defender_score = Score.new(number_of_tricks: tricks_for(defending_players).size).for_defense

    set_scores(attacker_score, defender_score)
  end

  def set_scores(attack_score, defense_score)
    if attacking_players.first.number_in_game.odd?
      round.odd_team_score = attack_score
      round.even_team_score = defense_score
    else
      round.odd_team_score = defense_score
      round.even_team_score = attack_score
    end
  end

  def successful_attack?
    attacker_tricks = tricks_for(attacking_players)

    attacker_tricks.count >= attempted_number_of_tricks
  end

  def tricks_for(team_members)
    tricks.select { |trick| team_members.include?(trick.cards.highest.player) }
  end

  def attacking_players
    if bid_winning_player.number_in_game.even?
      players.select { |player| player.number_in_game.even? }
    else
      players.select { |player| player.number_in_game.odd? }
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

  def add_error(message)
    errors << message
  end
end
