class NextBidder
  attr_reader :next_bidder, :errors

  def initialize(round)
    @round = round
    @errors = []
    @players = @round.game.players
    @next_bidder = nil
  end

  def call
    @round.with_lock do
      set_next_bidder
    end

    unless @next_bidder
      add_error("bidding is over")
    end
  end

  private

  def set_next_bidder
    passed_players_offset = 0

    until @next_bidder || passed_players_offset > 3
      incremented_index = next_bidder_index(passed_players_offset)

      @next_bidder = fetch_next_bidder(incremented_index)

      if bidder_has_already_passed?
        @next_bidder = nil
      end

      passed_players_offset += 1
    end
  end

  def bidder_has_already_passed?
    @round.passes.any? { |pass| pass.player == @next_bidder }
  end

  def next_bidder_index(offset)
    (@round.bids.count % @players.count) + offset
  end

  def fetch_next_bidder(index)
    index < @players.length ? @players[index] : @players[0]
  end

  def add_error(message)
    @errors << message
  end
end
