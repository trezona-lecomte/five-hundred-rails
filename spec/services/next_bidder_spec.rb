require "rails_helper"

RSpec.describe NextBidder, type: :service do
  fixtures :all
  let(:game)             { games(:bidding_game) }
  let(:find_next_bidder) { NextBidder.new(round) }

  describe "#call" do
    context "when there are no passes" do
      10.times do |n|
        context "when it is the first round" do
          let(:round) { rounds(:bidding_round) }

          before do
            submit_bids(round, n)
            find_next_bidder.call
          end

          it "returns the correct bidder" do
            expect(find_next_bidder.next_bidder).to eq(players("bidder#{(n % game.players.count) + 1}"))
          end
        end
      end
    end

    context "when there are passes" do
      3.times do |n|
        context "when it is the first round" do
          let(:round) { rounds(:bidding_round) }

          before do
            submit_passes(round, n)
            find_next_bidder.call
          end

          it "returns the correct bidder" do
            expect(find_next_bidder.next_bidder).to eq(players("bidder#{(n % game.players.count) + 1}"))
          end
        end
      end
    end

    context "when there is a bid and a pass" do
      context "when it is the first round" do
        let(:round) { rounds(:bidding_round) }

        before do
          submit_bids(round, 1)
          submit_passes(round, 1, 1)
          find_next_bidder.call
        end

        it "returns the correct bidder" do
          expect(find_next_bidder.next_bidder).to eq(players(:bidder3))
        end
      end
    end

    context "when there are multiple bids & multiple passes" do
      context "when it is the first round" do
        let(:round) { rounds(:bidding_round) }

        before do
          submit_bids(round, 1)      # player 1 bids
          submit_bids(round, 1, 1)   # player 2 bids
          submit_passes(round, 1, 2) # player 3 passes
          submit_bids(round, 1, 3)   # player 4 bids
          submit_bids(round, 1, 4)   # player 1 bids
          submit_passes(round, 1, 5) # player 2 passes
          find_next_bidder.call
        end

        it "returns the correct bidder" do
          expect(find_next_bidder.next_bidder).to eq(players(:bidder4))
        end
      end
    end

    context "when all players have passed" do
      let(:round) { rounds(:bidding_round) }

      before do
        submit_bids(round, 1)      # player 1 bids
        submit_bids(round, 1, 1)   # player 2 bids
        submit_passes(round, 1, 2) # player 3 passes
        submit_bids(round, 1, 3)   # player 4 bids
        submit_bids(round, 1, 4)   # player 1 bids
        submit_passes(round, 1, 5) # player 2 passes
        submit_passes(round, 1, 7) # player 4 passes
        submit_passes(round, 1, 8) # player 1 passes
        find_next_bidder.call
      end

      it "returns nil" do
        expect(find_next_bidder.next_bidder).to be_nil
      end

      it "sets a 'bidding is over' error" do
        expect(find_next_bidder.errors).to include("bidding is over")
      end
    end
  end

  def submit_bids(round, number_of_bids, previous_bids = 0)
    number_of_bids.times do |n|
      round.bids.create!(player: players("bidder#{((n + previous_bids) % game.players.count) + 1}"),
                         number_of_tricks: 6 + n + previous_bids,
                         suit: rand(0..(Bid.suits.length - 1)))
    end
  end

  def submit_passes(round, number_of_passes, previous_bids = 0)
    number_of_passes.times do |n|
      round.bids.create!(player: players("bidder#{((n + previous_bids) % game.players.count) + 1}"),
                         number_of_tricks: 0,
                         suit: 0)
    end
  end
end
