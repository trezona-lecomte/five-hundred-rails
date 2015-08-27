# TODO: add negative tests for bids having to be higher
require "rails_helper"

describe SubmitBid, type: :service do
  fixtures :all

  let(:suit)             { Suits::NO_SUIT }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { Bid::PASS_TRICKS }
  let(:service_args)     { { round: round, player: player, number_of_tricks: number_of_tricks, suit: suit } }

  subject(:service) { SubmitBid.new(**service_args) }

  BIDDING_IS_FINISHED_ERROR = "bidding for this round has finished"


  describe "#call" do
    before { allow(service).to receive(:valid?).and_return(validity) }

    context "when the submission is valid" do
      let(:validity) { true }

      it "submits the bid" do
        expect { service.call }.to change(Bid, :count).by(1)
      end
    end

    context "when the submission is invalid" do
      let(:validity) { false }

      it "doesn't submit the bid" do
        expect { service.call }.to_not change(Bid, :count)
      end
    end
  end

  describe "#bidding_is_open" do
    context "when the round is not in the bidding stage" do
      let(:round) { rounds(:playing_round) }

      before { service.valid? }

      it { is_expected.to be_invalid }

      it "has the correct 'round has finished' error" do
        expect(service.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
      end
    end
  end
end
