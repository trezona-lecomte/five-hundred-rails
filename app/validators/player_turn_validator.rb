class PlayerTurnValidator < ActiveModel::Validator
  def validate(play_card)
    unless this_players_turn?(
             play_card.players,
             play_card.round,
             play_card.player,
             play_card.trick
           )
      play_card.errors.add(:base, "it's not your turn to play")
    end
  end

  private

  def this_players_turn?(players, round, player, trick)
    if cards_played_in_current_trick?(trick)
      players_turn_based_on_cards_played?(players, trick, player)
    elsif first_trick?(trick)
      player_won_bidding_this_round?(round, player)
    else
      player_won_previous_trick?(round, player)
    end
  end

  def cards_played_in_current_trick?(trick)
    trick.cards_count > 0
  end

  def first_trick?(trick)
    trick.order_in_round.zero?
  end

  def player_won_bidding_this_round?(round, player)
    player == round.highest_bid.player
  end

  def player_won_previous_trick?(round, player)
    player == round.previous_trick.winning_player
  end

  def players_turn_based_on_cards_played?(players, trick, player)
    previous_card = trick.cards.max_by(&:order_in_trick)
    previous_player = previous_card.player

    player == next_player_in_order(previous_player, players)
  end

  def next_player_in_order(previous_player, players)
    players.detect do |player|
      player.order_in_game == (previous_player.order_in_game + 1) % players.size
    end
  end
end
