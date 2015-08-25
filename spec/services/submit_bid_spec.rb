# TODO: add negative tests for bids having to be higher
require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  fixtures :all

  let(:suit)             { Suits::NO_SUIT }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { Bid::PASS_TRICKS }
  let(:service_args)     { { round: round, player: player, number_of_tricks: number_of_tricks, suit: suit } }

  subject(:service) { SubmitBid.new(**service_args) }

  BIDDING_IS_FINISHED_ERROR = "bidding for this round has finished"
  BID_NOT_HIGH_ENOUGH_ERROR = "your bid isn't high enough"

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

  describe "#bid_is_high_enough" do
    context "when the bid is the first of the round" do
        let(:number_of_tricks) { (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.sample }

        it { is_expected.to be_valid }
    end

    context "when the bid is high enough" do
      let(:previous_tricks_bid) { (Bid::MIN_TRICKS..(Bid::MAX_TRICKS - 1)).to_a.sample }
      let(:player)              { players(:bidder2) }

      before do
        SubmitBid.new(round: round,
                      player: players(:bidder1),
                      suit: Suits::HEARTS,
                      number_of_tricks: previous_tricks_bid).call
      end

      context "when the bid is a pass" do
        let(:number_of_tricks) { Bid::PASS_TRICKS }

        it { is_expected.to be_valid }
      end

      context "when the bid number of tricks are higher than the previous bid" do
        let(:suit)             { Suits::HEARTS }
        let(:number_of_tricks) { ((previous_tricks_bid + 1)..Bid::MAX_TRICKS).to_a.sample }

        it { is_expected.to be_valid }
      end

      context "when the bid number of tricks are equal but the suit is higher than the previous bid" do
        let(:suit)             { Suits::NO_SUIT }
        let(:number_of_tricks) { previous_tricks_bid }

        it { is_expected.to be_valid }
      end
    end

    context "when the bid isn't high enough" do
      let(:previous_tricks_bid) { (Bid::MIN_TRICKS..(Bid::MAX_TRICKS - 1)).to_a.sample }
      let(:player)              { players(:bidder2) }

      before do
        SubmitBid.new(round: round,
                      player: players(:bidder1),
                      suit: Suits::HEARTS,
                      number_of_tricks: previous_tricks_bid).call
      end

      context "when the number of tricks aren't higher than the previous bid" do
        let(:suit)             { Suits::NO_SUIT }
        let(:number_of_tricks) { previous_tricks_bid - 1 }

        before { service.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'bid not high enough' error" do
          expect(service.errors[:base]).to include(BID_NOT_HIGH_ENOUGH_ERROR)
        end
      end

      context "when the number of tricks and the suit are the same as the previous bid" do
        let(:suit)             { Suits::HEARTS }
        let(:number_of_tricks) { previous_tricks_bid }

        before { service.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'bid not high enough' error" do
          expect(service.errors[:base]).to include(BID_NOT_HIGH_ENOUGH_ERROR)
        end
      end

      context "when the number of tricks is the same and the suit is lower than the previous bid" do
        let(:suit)             { Suits::DIAMONDS }
        let(:number_of_tricks) { previous_tricks_bid }

        before { service.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'bid not high enough' error" do
          expect(service.errors[:base]).to include(BID_NOT_HIGH_ENOUGH_ERROR)
        end
      end
    end
  end
end
