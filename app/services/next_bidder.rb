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

      passed_players_offset = 0

      until (@next_bidder && @round.passes.none? { |pass| pass.player == @next_bidder }) || passed_players_offset > 3
        next_player_index = (@round.bids.count % @players.count) + passed_players_offset

        if next_player_index < @players.length
          @next_bidder = @players[next_player_index]
        else
          @next_bidder = @players[0]
        end

        passed_players_offset += 1
      end
    end
  end
end
