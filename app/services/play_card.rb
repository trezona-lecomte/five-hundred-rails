class PlayCard
  include ActiveModel::Validations

  attr_reader :round, :card, :trick

  validate :card_can_be_played

  def initialize(trick: trick, player: player, card: card)
    @trick = trick
    @round = trick.round
    @player = player
    @card = card
  end

  def call
    @round.with_lock do
      valid? && play_card
    end
  end

  private

  def card_can_be_played
    if !card_in_hand?
      errors.add(:base, "you don't have this card in your hand")
    elsif !round.in_playing_stage?
      errors.add(:base, "cards can't be played on this round")
    elsif !trick_active?
      errors.add(:base, "this trick is not active")
    elsif !players_turn?
      errors.add(:base, "it's not your turn to play")
    end
  end

  def card_in_hand?
    (card.player == @player) && card.trick.blank?
  end

  def trick_active?
    @trick == round.current_trick
  end

  def players_turn?
    find_next_player = FindNextPlayer.new(round)
    find_next_player.call

    @player == find_next_player.next_player
  end

  def play_card
    @trick.cards << @card
    @trick.reload
    @card.order_in_trick = @trick.cards_count

    # TODO follow pattern from other service for bubbling errors up
    unless @card.save
      errors.add("you can't play this card right now: #{@card.errors.full_messages}, #{@trick.errors.full_messages}")
    end
  end
end
