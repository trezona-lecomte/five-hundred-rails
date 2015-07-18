class PlayCard
  attr_reader :round, :player, :card, :trick, :error

  def initialize(round:, player:)
    @round = round
    @player = player
  end

  def call(playing_card:, trick:)
    add_error("Cards can't be played at this stage of the game.") and return unless round.playing?

    @trick = trick

    if round.next_player?(player)
      trick.playing_cards << playing_card
    else
      add_error("It's not your turn to play.")
    end
  end

  private

  def add_error(message)
    @error = message
  end

  # def valid_play?(playing_card)
  #   round.next_player?(playing_card.player)
  # end
end
