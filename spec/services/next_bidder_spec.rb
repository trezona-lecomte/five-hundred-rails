require "rails_helper"

RSpec.describe NextBidder, type: :service do
  fixtures :all
  let(:game)             { games(:bidding_game) }
  #let(:round)            { rounds(:bidding_round) }
  let(:find_next_bidder) { NextBidder.new(round) }

  describe "#call" do
    context "when there are no passes" do
      10.times do |n|
        context "when it is the first round" do
          let(:round) { rounds(:bidding_round) }

          before do
            submit_bids(n)
            find_next_bidder.call
          end

          it "returns the correct bidder" do
            expect(find_next_bidder.next_bidder).to eq(players("bidder#{(n % game.players.count) + 1}"))
          end
        end
      end
    end

    context "when there are passes" do
      before { submit_passes(1) }

      it "returns the correct bidder" do

      end
    end

    context "when it is the fourth round" do

    end

    context "when it is the seventh round" do

    end
  end

  def submit_bids(number_of_bids)
    number_of_bids.times do |n|
      round.bids.create!(player: players("bidder#{(n % game.players.count) + 1}"),
                         number_of_tricks: 6 + n,
                         suit: rand(0..(Bid.suits.length - 1)))
    end
  end

  def submit_passes(number_of_passes)
    number_of_passes.times do |n|
      round.bids.create!(player: players("bidder#{(n % game.players.count) + 1}"),
                         number_of_tricks: 0,
                         suit: 0)
    end
  end
end
