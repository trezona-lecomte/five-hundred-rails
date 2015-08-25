class PlayCardValidator < ActiveModel::Validator
  def validate(play_card)

    if !card_in_this_players_hand?(play_card.player, play_card.card)
      play_card.errors.add(:base, "you don't have this card in your hand")

    elsif !play_card.round.in_playing_stage?
      play_card.errors.add(:base, "this round isn't in the playing stage")

    elsif !this_trick_is_current?(play_card.round, play_card.trick)
      play_card.errors.add(:base, "this trick is not active")

    elsif !this_players_turn?(play_card.round, play_card.player)
      play_card.errors.add(:base, "it's not your turn to play")
    end
  end

  private

  def card_in_this_players_hand?(player, card)
    (card.player == player) && card.trick.blank?
  end

  def this_trick_is_current?(round, trick)
    trick == round.current_trick
  end

  def this_players_turn?(round, player)
    if round.current_trick.cards.present?
      this_players_turn_based_on_cards_played?(round, player)
    elsif first_trick?(round)
      this_player_won_bidding_this_round?(round, player)
    else
      this_player_won_previous_trick?(round, player)
    end
  end

  def first_trick?(round)
    round.current_trick.order_in_round.zero?
  end

  def this_player_won_bidding_this_round?(round, player)
    player == round.highest_bid.player
  end

  def this_player_won_previous_trick?(round, player)
    player == round.previous_trick.winning_player
  end

  # TODO: tidy to use similar method as BidSubmissionValidator (need mo' time!)
  def this_players_turn_based_on_cards_played?(round, player)
    players = round.game.players

    last_player_number = round.current_trick.cards.last_played.player.order_in_game

    next_player_number = last_player_number < players.length - 1 ? last_player_number + 1 : 0

    player == players.find_by(order_in_game: next_player_number)
  end
end
