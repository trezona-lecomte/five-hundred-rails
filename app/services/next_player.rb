class NextPlayer
  attr_reader :round, :errors, :next_player

  def initialize(round)
    @round = round
    @errors = []
    @players = @round.game.players
    @next_player = nil
  end

  def call
    @round.with_lock do
      if @round.tricks.one?
        active_trick = @round.tricks.first

        if active_trick.cards.none?           # winning bidder
          @next_player = @players.first(2).last
        else
          @next_player = next_player_based_on_cards_played(active_trick)
        end
      else
        active_trick = @round.tricks.last

        if active_trick.cards.none?           # winner of last trick
          index_of_active_trick = @round.tricks.index(active_trick)
          previous_trick = @round.tricks[index_of_active_trick - 1]
          previous_trick = TricksDecorator.new(previous_trick)

          @next_player = previous_trick.winning_card.player
        else
          @next_player = next_player_based_on_cards_played(active_trick)
        end
      end
    end
  end

  private

  def next_player_based_on_cards_played(active_trick)
    last_player = active_trick.cards.order(updated_at: :desc)[0].player
    next_player_index = @players.index(last_player) + 1

    if next_player_index < @players.length
      @players[next_player_index]
    else
      @players[0]
    end
  end
end
