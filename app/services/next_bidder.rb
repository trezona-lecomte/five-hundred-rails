class NextBidder
  attr_reader :next_bidder, :messages

  def initialize(round)
    @round = round
    @messages = []
    @players = @round.game.players
    @next_bidder = nil
  end

  def call
    @round.with_lock do
      set_next_bidder
    end

    unless @next_bidder
      add_message("bidding for this round is finished")
    end
  end

  private

  def set_next_bidder
    passed_players_offset = 0

    until @next_bidder || passed_players_offset > 3
      incremented_index = next_bidder_index(passed_players_offset)

      bidder = fetch_next_bidder(incremented_index)

      unless bidder_has_already_passed?(bidder)
        @next_bidder = bidder
      end

      passed_players_offset += 1
    end
  end

  def bidder_has_already_passed?(bidder)
    @round.bids.passes.any? { |pass| pass.player == bidder }
  end

  def next_bidder_index(offset)
    (@round.bids.count % @players.count) + offset
  end

  def fetch_next_bidder(index)
    index < @players.length ? @players[index] : @players[0]
  end

  def add_message(message)
    @messages << message
  end
end
