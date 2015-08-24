require "rails_helper"

RSpec.describe Round, type: :model do
  fixtures :all

  let(:round)  { rounds(:playing_round) }

  it { should validate_presence_of :game }
  it { should validate_presence_of :odd_players_score }
  it { should validate_presence_of :even_players_score }
  it { should validate_numericality_of(:odd_players_score).only_integer }
  it { should validate_numericality_of(:even_players_score).only_integer }

  it { should validate_numericality_of(:order_in_game).is_greater_than_or_equal_to(0) }

  context "when destroyed" do
    it "destroys all dependent cards" do
      expect { round.destroy }.to change(Card, :count).by(-43)
    end

    it "destroys all dependent bids" do
      expect { round.destroy }.to change(Bid, :count).by(-9)
    end

    it "destroys all dependent tricks" do
      expect { round.destroy }.to change(Trick, :count).by(-10)
    end
  end

  describe "#current_trick" do
    context "when no tricks have been finished" do
      it "returns the first trick" do
        expect(round.current_trick).to eq(tricks(:trick_1))
      end
    end

    context "when the first trick has been finished" do
      let(:trick) { tricks(:trick_1) }

      before do
        trick.cards << cards(:king_of_spades)
        trick.cards << cards(:jack_of_spades)
        trick.cards << cards(:nine_of_spades)
        trick.cards << cards(:five_of_spades)
      end

      it "returns the second trick" do
        expect(round.current_trick).to eq(tricks(:trick_2))
      end
    end

    context "when all the tricks have been finished" do
      let(:round) { rounds(:finished_round) }

      it "returns nil" do
        expect(round.current_trick).to be nil
      end
    end
  end

  describe "#previous_trick" do
    context "when no tricks have been finished" do
      it "returns nil" do
        expect(round.previous_trick).to be nil
      end
    end

    context "when the first trick has been finished" do
      let(:trick) { tricks(:trick_1) }

      before do
        trick.cards << cards(:king_of_spades)
        trick.cards << cards(:jack_of_spades)
        trick.cards << cards(:nine_of_spades)
        trick.cards << cards(:five_of_spades)
      end

      it "returns the first trick" do
        expect(round.previous_trick).to eq(tricks(:trick_1))
      end
    end

    context "when all the tricks have been finished" do
      let(:round) { rounds(:finished_round) }

      it "returns the last trick" do
        expect(round.previous_trick).to eq(tricks(:finished_trick_10))
      end
    end
  end

  describe "#in_bidding_stage?" do
    subject { round }

    context "when the round is in the bidding stage" do
      let(:round) { rounds(:bidding_round) }

      it { is_expected.to be_in_bidding_stage }
    end

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      it { is_expected.to_not be_in_bidding_stage }
    end

    context "when the round is finished" do
      let(:round) { rounds(:finished_round) }

      it { is_expected.to_not be_in_bidding_stage }
    end
  end

  describe "#in_playing_stage?" do
    subject { round }

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      it { is_expected.to be_in_playing_stage }
    end

    context "when the round is in the bidding stage" do
      let(:round) { rounds(:bidding_round) }

      it { is_expected.to_not be_in_playing_stage }
    end

    context "when the round is finished" do
      let(:round) { rounds(:finished_round) }

      it { is_expected.to_not be_in_playing_stage }
    end
  end

  describe "#finished?" do
    subject { round }

    context "when the round is finished" do
      let(:round) { rounds(:finished_round) }

      it { is_expected.to be_finished }
    end

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      it { is_expected.to_not be_finished }
    end

    context "when the round is in the bidding stage" do
      let(:round) { rounds(:bidding_round) }

      it { is_expected.to_not be_finished }
    end
  end
end
