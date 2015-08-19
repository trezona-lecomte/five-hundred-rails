require "rails_helper"

RSpec.describe RoundsDecorator, type: :decorator do
  fixtures :all
  let(:round)           { rounds(:playing_round) }
  let(:decorated_round) { RoundsDecorator.new(round) }
  let(:player)          { players(:player1) }

  # TODO move to round_spec
  # describe "#in_bidding_stage?" do
  #   subject { decorated_round.bidding? }

  #   context "when bidding hasn't finished yet" do
  #     let(:round) { rounds(:bidding_round) }

  #     it { is_expected.to be true }
  #   end

  #   context "when bidding has finished" do
  #     it { is_expected.to be false }
  #   end
  # end

  # describe "#playing?" do
  #   subject { decorated_round.playing? }

  #   context "when playing hasn't yet started" do
  #     let(:round) { rounds(:bidding_round) }

  #     it { is_expected.to be_falsey }
  #   end

  #   context "when playing has begun and not yet finished" do
  #     it { is_expected.to be_truthy }
  #   end

  #   context "when playing has finished" do
  #     before { allow(decorated_round).to receive(:active_trick).and_return(nil) }

  #     it { is_expected.to be_falsey }
  #   end
  # end

  # describe "#finished?" do
  #   subject { decorated_round.finished? }

  #   context "when the round has incomplete tricks" do
  #     it { is_expected.to be false }
  #   end

  #   context "when all tricks in the round are complete" do
  #     before { allow(decorated_round).to receive(:active_trick).and_return(nil) }

  #     it { is_expected.to be true }
  #   end
  # end

  describe "#unplayed cards" do
    let(:player)    { players(:player2) }
    let(:card)      { cards(:ten_of_hearts) }
    let(:all_cards) { round.cards.where(player: player) }

    subject { decorated_round.unplayed_cards(player) }

    context "when a player hasn't played any cards" do
      it { is_expected.to eq(all_cards) }
    end

    context "when a player has played a card" do
      before { PlayCard.new(decorated_round.current_trick, player, card).call }

      it { is_expected.to eq(all_cards - [card]) }
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

    # TODO broken by refactor that only returns available bids when bidding
    # context "when the highest bid is 8 spades" do
    #   it "returns a list of all bids higher than 8 spades, as well as a pass" do
    #     expect(decorated_round.available_bids.count).to eq(15)
    #   end
    # end
  end
end
