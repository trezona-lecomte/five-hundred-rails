require "rails_helper"

describe GenerateAvailableBids, type: :service do
  fixtures :all

  describe "#call" do
    let(:round)       { rounds(:bidding_round) }
    let(:service)     { GenerateAvailableBids.new(round) }
    let(:call_result) { service.call }

    context "when the round is in the bidding stage" do
      before { service.call }

      let(:bids)        { service.available_bids }

      context "when no bids have been made" do
        it "returns true" do
          expect(call_result).to be_truthy
        end

        it "generates a full list of all possible bids" do
          expect(bids.count).to eq(26)
        end
      end

      context "when bids have been made" do
        let(:highest_bid)   { Bid.create!(round: round,
                                          pass: false,
                                          suit: Suits::NO_SUIT,
                                          number_of_tricks: Bid::MAX_TRICKS,
                                          player: players(:bidder1)) }
        let(:excluded_bids) { excluded_bids_for(highest_bid) }

        before do
          allow(service).to receive(:any_non_pass_bids_made_yet?).and_return(true)
          allow(round).to receive(:highest_bid).and_return(highest_bid)
          service.call
        end

        it "returns true" do
          expect(call_result).to be_truthy
        end

        it "generates a list of all bids higher than the last submitted bid & and a pass" do
          expect(service.available_bids.count).to eq(1)
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
  end
end
