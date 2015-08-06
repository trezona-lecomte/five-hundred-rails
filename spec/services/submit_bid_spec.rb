require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  fixtures :all
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { 6 }
  let(:suit)             { "spades" }
  let(:submit_bid)       { SubmitBid.new(round, player, number_of_tricks, suit) }

  describe "#call" do
    context "when no bids have been made" do
      let(:round) { rounds(:bidding_round) }

      context "when the first player bids" do
        it "submits the bid" do
          expect{ submit_bid.call }.to change(Bid, :count).by(1)
          expect(round.bids).to be_one
        end
      end

      context "when anyone but the first player bids" do
        context "when the second player bids" do
          let(:player) { players(:bidder2) }

          it "doesn't submit the bid" do
            expect{ submit_bid.call }.to_not change(Bid, :count)
          end

          it "sets a 'not your turn' error" do
            submit_bid.call

            expect(submit_bid.errors).to include("it's not your turn to bid")
          end
        end

        context "when the third player bids" do
          let(:player) { players(:bidder3) }

          it "doesn't submit the bid" do
            expect{ submit_bid.call }.to_not change(Bid, :count)
          end

          it "sets a 'not your turn' error" do
            submit_bid.call

            expect(submit_bid.errors).to include("it's not your turn to bid")
          end
        end
        context "when the fourht player bids" do
          let(:player) { players(:bidder4) }

          it "doesn't submit the bid" do
            expect{ submit_bid.call }.to_not change(Bid, :count)
          end

          it "sets a 'not your turn' error" do
            submit_bid.call

            expect(submit_bid.errors).to include("it's not your turn to bid")
          end
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
