require "rails_helper"

RSpec.describe RoundsDecorator, type: :decorator do
  fixtures :all
  let(:round) { rounds(:playing_round) }
  let(:decorated_round) { RoundsDecorator.new(round) }

  describe "#bidding?" do
    subject { decorated_round.bidding? }

    context "when bidding hasn't finished yet" do
      let(:round) { rounds(:bidding_round) }

      it { is_expected.to be true }
    end

    context "when bidding has finished" do
      it { is_expected.to be false }
    end
  end

  describe "#playing?" do
    subject { decorated_round.playing? }

    context "when playing hasn't yet started" do
      let(:round) { rounds(:bidding_round) }

      it { is_expected.to be false }
    end

    context "when playing has begun and not yet finished" do
      it { is_expected.to be_truthy }
    end

    context "when playing has finished" do

    end
  end

  describe "#stage" do

  end

  describe "#kitty" do
    let(:kitty) { decorated_round.kitty }

    it "returns a single collection of cards in the kitty" do
      expect(kitty.count).to eq(3)
    end

    it "returns only cards without an associated player" do
      kitty.each do |card|
        expect(card.player).to be_nil

      end
    end
  end

  describe "#passes" do
    let(:passes)           { decorated_round.passes }
    let(:number_of_passes) { round.bids.where(number_of_tricks: 0).count }

    it "returns all bids in the round that are passes" do
      expect(passes.count).to eq(4)
    end

    it "returns only bids with a 'number_of_tricks' of 0" do
      passes.each do |pass|
        expect(pass.number_of_tricks).to eq(0)
      end
    end
  end

  describe "#winning_bid" do
    let(:winning_bid) { decorated_round.winning_bid }
    let(:expected_bid) { bids(:sixth_bid) }

    it "returns the bid with the highest suit/tricks from the round" do
      expect(winning_bid).to eq(expected_bid)
    end
  end

  describe "#available_bids" do
    context "when there haven't been any bids" do
      let(:round) { rounds(:bidding_round) }

      it "returns a list of all possible bids" do
        expect(decorated_round.available_bids.count).to eq(26)
      end
    end

    context "when the highest bid is 8 spades" do
      it "returns a list of all bids higher than 8 spades, as well as a pass" do
        expect(decorated_round.available_bids.count).to eq(15)
      end
    end
  end
end
