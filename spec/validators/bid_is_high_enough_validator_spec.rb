require "rails_helper"

describe BidIsHighEnoughValidator, type: :validator do
  fixtures :all

  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:pass)             { false }
  let(:suit)             { Suits::NO_SUIT }
  let(:number_of_tricks) { Bid::MIN_TRICKS }

  subject(:bid) {
    Bid.new(
      round: round,
      player: player,
      pass: pass,
      suit: suit,
      number_of_tricks: number_of_tricks
    )
  }

  BID_NOT_HIGH_ENOUGH_ERROR = "your bid isn't high enough"

  describe "#bid_is_high_enough" do
    context "when the bid is the first of the round" do
        let(:number_of_tricks) { (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.sample }

        it { is_expected.to be_valid }
    end

    context "when the bid is high enough" do
      let(:previous_tricks_bid) { (Bid::MIN_TRICKS..(Bid::MAX_TRICKS - 1)).to_a.sample }
      let(:player)              { players(:bidder2) }

      before do
        Bid.non_passes.create!(
          round: round,
          player: players(:bidder1),
          suit: Suits::HEARTS,
          number_of_tricks: previous_tricks_bid
        )
      end

      context "when the bid is a pass" do
        let(:pass)             { true }
        let(:suit)             { nil }
        let(:number_of_tricks) { nil }

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
        Bid.create!(
          round: round,
          player: players(:bidder1),
          suit: Suits::HEARTS,
          number_of_tricks: previous_tricks_bid
        )
      end

      context "when the number of tricks aren't higher than the previous bid" do
        let(:suit)             { Suits::NO_SUIT }
        let(:number_of_tricks) { previous_tricks_bid - 1 }

        before { bid.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'bid not high enough' error" do
          expect(bid.errors[:base]).to include(BID_NOT_HIGH_ENOUGH_ERROR)
        end
      end

      context "when the number of tricks and the suit are the same as the previous bid" do
        let(:suit)             { Suits::HEARTS }
        let(:number_of_tricks) { previous_tricks_bid }

        before { bid.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'bid not high enough' error" do
          expect(bid.errors[:base]).to include(BID_NOT_HIGH_ENOUGH_ERROR)
        end
      end

      context "when the number of tricks is the same and the suit is lower than the previous bid" do
        let(:suit)             { Suits::DIAMONDS }
        let(:number_of_tricks) { previous_tricks_bid }

        before { bid.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'bid not high enough' error" do
          expect(bid.errors[:base]).to include(BID_NOT_HIGH_ENOUGH_ERROR)
        end
      end
    end
  end
end
