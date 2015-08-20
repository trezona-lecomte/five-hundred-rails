require "rails_helper"

RSpec.describe FindAvailableBids, type: :service do
  fixtures :all

  describe "#call" do
    let(:round)       { rounds(:bidding_round) }
    let(:service)     { FindAvailableBids.new(round) }
    let(:call_result) { service.call }

    context "when the round is in the bidding stage" do
      before { service.call }

      let(:bids)        { service.available_bids }

      context "when no bids have been made" do
        it "returns true" do
          expect(call_result).to be true
        end

        it "generates a full list of all possible bids" do
          expect(bids).to eq(all_possible_bids)
        end
      end

      context "when bids have been made" do
        let(:highest_bid)   { Bid.create!(round: round,
                                          suit: "spades",
                                          number_of_tricks: 8,
                                          player: players(:bidder1)) }
        let(:excluded_bids) { excluded_bids_for(highest_bid) }

        before do
          allow(service).to receive(:any_bids?).and_return(true)
          allow(round).to receive(:highest_bid).and_return(highest_bid)
          service.call
        end

        it "returns true" do
          expect(call_result).to be true
        end

        it "generates a list of all bids higher than the last submitted bid & and a pass" do
          expect(service.available_bids).to eq(all_possible_bids - excluded_bids)
        end
      end
    end

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      it "returns false" do
        expect(call_result).to be false
      end
    end

    context "when the round is finished" do
      let(:round) { rounds(:finished_round) }

      it "returns false" do
        expect(call_result).to be false
      end
    end

    def all_possible_bids
      [[0, "no_suit"]] + (6..10).to_a.product(Bid.suits.keys)
    end

    def excluded_bids_for(highest_bid)
      bids_lower_than(highest_bid) + [[highest_bid.number_of_tricks, highest_bid.suit]]
    end

    def bids_lower_than(highest_bid)
      highest_tricks = highest_bid.number_of_tricks
      highest_suit = highest_bid.suit

      all_possible_bids.select do |tricks, suit|
        tricks != 0 &&
          (tricks < highest_tricks || (tricks == highest_tricks && Bid.suits[suit] < Bid.suits[highest_suit]))
      end
    end
  end

end
