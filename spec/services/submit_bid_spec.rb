require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  fixtures :all
  let(:game)             { games(:bidding_game) }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:player1) }
  let(:number_of_tricks) { 6 }
  let(:suit)             { "spades" }
  let(:submit_bid)       { SubmitBid.new(round, player, number_of_tricks, suit) }

  describe "#call" do
    context "when no bids have been made" do
      context "when the first player bids" do
        it "submits the bid" do
          expect{ submit_bid.call }.to change(Bid, :count).by(1)
          expect(round.bids).to be_one
        end
      end

      context "when anyone but the first player bids" do
        let(:player) { players(:player2) }

        it "doesn't submit the bid" do
          expect{ submit_bid.call }.to_not change(Bid, :count)
        end

        it "sets a 'not your turn' error" do

        end
      end
    end

    context "when some bids have been made" do
      context "when the correct player bids" do

      end

      context "when the incorrect player bids" do

      end
    end
  end
end
