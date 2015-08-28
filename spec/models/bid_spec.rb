require "rails_helper"

describe Bid, type: :model do
  fixtures :all

  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:pass)             { false }
  let(:number_of_tricks) { Bid::MIN_TRICKS }
  let(:suit)             { Suits::NO_SUIT}
  let(:bid_args)         { {
                             round: round,
                             player: player,
                             pass: pass,
                             number_of_tricks: number_of_tricks,
                             suit: suit
                           } }

  subject(:bid) { Bid.new(**bid_args) }

  BIDDING_IS_FINISHED_ERROR = "bidding for this round has finished"

  describe "validations" do
    it { is_expected.to validate_presence_of :round }
    it { is_expected.to validate_presence_of :player }
    it { is_expected.to validate_inclusion_of(:number_of_tricks).in_array(Bid::ALLOWED_TRICKS) }

    context "when pass is true" do
      let(:pass) { true }

      context "when number_of_tricks is present" do
        it { is_expected.to be_invalid }
      end

      context "when suit is present" do
        it { is_expected.to be_invalid }
      end

      context "when number_of_tricks & suit are absent" do
        let(:suit) { nil }
        let(:number_of_tricks) { nil }

        it { is_expected.to be_valid }
      end
    end

    context "when pass is false" do
      let(:pass) { false }

      context "when number_of_tricks & suit are present" do
        it { is_expected.to be_valid }
      end

      context "when number_of_tricks is absent" do
        let(:number_of_tricks) { nil }

        it { is_expected.to be_invalid }
      end

      context "when suit is absent" do
        let(:suit) { nil }

        it { is_expected.to be_invalid }
      end
    end

    describe "#bidding_is_open" do
      context "when the round is not in the bidding stage" do
        let(:round) { rounds(:playing_round) }

        before { bid.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'round has finished' error" do
          expect(bid.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
        end
      end
    end
  end
end
