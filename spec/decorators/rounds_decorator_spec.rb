require "rails_helper"

RSpec.describe RoundsDecorator, type: :decorator do
  fixtures :all
  let(:round) { rounds(:playing_round) }
  let(:decorated_round) { RoundsDecorator.new(round) }

  describe "#hands" do
    let(:hands) { decorated_round.hands }
    let(:cards) { hands.values.reduce(:+) }

    it "returns a hand per each player in the round" do
      expect(hands.count).to eq(4)
    end

    it "returns 40 cards across all the hands" do
      expect(cards.count).to eq(40)
    end

    it "returns only cards with an associated player" do
      cards.each do |card|
        expect(card.player).to_not be_nil
      end
    end
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
end
