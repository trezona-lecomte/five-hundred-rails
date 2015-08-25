class PlayerTurnValidator < ActiveModel::Validator
  def validate(play_card)
    unless this_players_turn?(play_card.round, play_card.player)
      play_card.errors.add(:base, "it's not your turn to play")
    end
  end

  private

  def this_players_turn?(round, player)
    if cards_played_in_current_trick?(round)
      players_turn_based_on_cards_played?(round, player)
    elsif first_trick?(round)
      player_won_bidding_this_round?(round, player)
    else
      player_won_previous_trick?(round, player)
    end
  end

  def cards_played_in_current_trick?(round)
    round.current_trick.cards.present?
  end

  def first_trick?(round)
    round.current_trick.order_in_round.zero?
  end

  def player_won_bidding_this_round?(round, player)
    player == round.highest_bid.player
  end

  def player_won_previous_trick?(round, player)
    player == round.previous_trick.winning_player
  end

  def players_turn_based_on_cards_played?(round, player)
    players = round.game.players
    previous_player = round.current_trick.cards.last_played.player

    player == next_player_in_order(previous_player, players)
  end

  def next_player_in_order(previous_player, players)
    players.detect do |player|
      player.order_in_game == (previous_player.order_in_game + 1) % players.size
    end
  end
end
