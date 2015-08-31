class PlayCard
  include ActiveModel::Validations

  attr_reader :round, :trick, :player, :card

  # TODO use singular version if apostrophe is required:
  validate :card_is_in_players_hand
  validate :trick_can_be_played_on
  validates_with PlayerTurnValidator

  def initialize(round:, player:, card:)
    @round = round
    @trick = round.current_trick
    @player = player
    @card = card
  end

  def call
    round.with_lock do
      valid? && play_card!
    end
  end

  private

  def card_is_in_players_hand
    if card.played? || !player_owns_card?
      errors.add(:base, "you don't have this card in your hand")
    end
  end

  def trick_can_be_played_on
    unless trick.cards_count < Trick::MAX_CARDS
      errors.add(:base, "this round isn't in the playing stage")
    end
  end

  def player_owns_card?
    card.player_id == player.id
  end

  def play_card!
    trick.cards << card
    trick.reload
    card.order_in_trick = trick.cards_count

    card.save!
  end
end
