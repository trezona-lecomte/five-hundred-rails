class PlayCard
  include ActiveModel::Validations

  attr_reader :round, :trick, :player, :card

  validate :trick_is_current
  validate :card_is_in_players_hand
  validate :round_is_in_playing_stage
  validates_with PlayerTurnValidator

  def initialize(trick:, player:, card:)
    @trick = trick
    @round = trick.round
    @player = player
    @card = card
  end

  def call
    round.with_lock do
      valid? && play_card!
    end
  end

  private

  def trick_is_current
    if trick != round.current_trick
      errors.add(:base, "this trick is not active")
    end
  end

  def card_is_in_players_hand
    if card.played? || !player_owns_card?
      errors.add(:base, "you don't have this card in your hand")
    end
  end

  def player_owns_card?
    card.player == player
  end

  def round_is_in_playing_stage
    unless round.in_playing_stage?
      errors.add(:base, "this round isn't in the playing stage")
    end
  end

  def play_card!
    trick.cards << card
    trick.reload
    card.order_in_trick = trick.cards_count

    card.save!
  end
end
