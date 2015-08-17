require "rails_helper"

RSpec.describe RoundsDecorator, type: :decorator do
  fixtures :all
  let(:round)           { rounds(:playing_round) }
  let(:decorated_round) { RoundsDecorator.new(round) }
  let(:player)          { players(:player1) }

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

      it { is_expected.to be_falsey }
    end

    context "when playing has begun and not yet finished" do
      it { is_expected.to be_truthy }
    end

    context "when playing has finished" do
      before { allow(decorated_round).to receive(:active_trick).and_return(nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe "#finished?" do
    subject { decorated_round.finished? }

    context "when the round has incomplete tricks" do
      it { is_expected.to be false }
    end

    context "when all tricks in the round are complete" do
      before { allow(decorated_round).to receive(:active_trick).and_return(nil) }

      it { is_expected.to be true }
    end
  end

  describe "#unplayed cards" do
    let(:player)    { players(:player2) }
    let(:card)      { cards(:ten_of_hearts) }
    let(:all_cards) { round.cards.where(player: player) }

    subject { decorated_round.unplayed_cards(player) }

    context "when a player hasn't played any cards" do
      it { is_expected.to eq(all_cards) }
    end

    context "when a player has played a card" do
      before { PlayCard.new(decorated_round.active_trick, player, card).call }

      it { is_expected.to eq(all_cards - [card]) }
    end
  end

  describe "#previous_trick" do
    subject { decorated_round.previous_trick }

    context "when it is the first trick" do
      binding.pry
      it { is_expected.to be nil }
    end

    context "when it is the second trick" do
      before do
        %w(2 3 4 1).each do |n|
          player = players("player#{n}")
          card = round.cards.where(player: player).sample
          pc = PlayCard.new(decorated_round.active_trick, player, card)
          pc.call
        end
      end

      it { is_expected.to eq(tricks(:trick_1)) }
    end
  end

  describe "#previous_trick_winner" do
    subject { decorated_round.previous_trick_winner }

    context "when it is the first trick" do
      it { is_expected.to be nil }
    end

    context "when player 1 won the first trick" do
      before do
        play_card = PlayCard.new(decorated_round.active_trick,
                                 players(:player2),
                                 cards(:nine_of_clubs))
        play_card.call

        play_card = PlayCard.new(decorated_round.active_trick,
                                 players(:player3),
                                 cards(:seven_of_clubs))
        play_card.call

        play_card = PlayCard.new(decorated_round.active_trick,
                                 players(:player4),
                                 cards(:five_of_clubs))
        play_card.call

        play_card = PlayCard.new(decorated_round.active_trick,
                                 players(:player1),
                                 cards(:king_of_clubs))
        play_card.call
      end

      it { is_expected.to eq(players(:player1)) }
    end
  end

  describe "#active_trick" do
    subject { decorated_round.active_trick }

    context "when the round isn't yet in the playing stage" do
      let(:round) { rounds(:bidding_round) }

      it { is_expected.to be_nil }
    end

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      context "when it is the first trick" do
        it { is_expected.to eq(round.tricks.order(number_in_round: :asc).first) }
      end

      context "when it is a subsequent trick" do
        before do
          decorated_round.active_trick.cards << cards(:jack_of_hearts)
          decorated_round.active_trick.cards << cards(:ten_of_hearts)
          decorated_round.active_trick.cards << cards(:nine_of_hearts)
          decorated_round.active_trick.cards << cards(:eight_of_hearts)
        end

        it { is_expected.to eq(round.tricks.order(number_in_round: :asc).first(2).last) }
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
