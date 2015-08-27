require "rails_helper"

describe Card, type: :model do
  let(:round)          { Game.create!.rounds.create!(odd_players_score: 0, even_players_score: 0, order_in_game: 0) }
  let(:trick)          { round.tricks.create!(order_in_round: 0) }
  let(:rank)           { Card.ranks.keys.first }
  let(:suit)           { Card.suits.keys.first }
  let(:order_in_trick) { nil }

  subject(:card) { Card.new(rank: rank, suit: suit, round: round, order_in_trick: order_in_trick) }

  describe "validations" do
    it { is_expected.to     validate_presence_of :suit }
    it { is_expected.to     validate_presence_of :rank }
    it { is_expected.to_not validate_presence_of :player }
    it { is_expected.to_not validate_presence_of :trick }
    it { is_expected.to_not validate_presence_of :order_in_trick }
    it { is_expected.to     validate_numericality_of(:order_in_trick).is_greater_than_or_equal_to(0).allow_nil}

    context "when no round is present" do
      let(:round) { nil }

      before { card.valid? }

      it { is_expected.to be_invalid }

      it "sets a 'round can't be blank' error" do
        expect(card.errors[:round]).to include("can't be blank")
      end
    end

    context "when rank & suit aren't unique within a round" do
      before do
        round.cards.create!(rank: rank, suit: suit)
        card.valid?
      end

      it { is_expected.to be_invalid }

      it "sets a 'has already been taken' error" do
        expect(card.errors[:round]).to include("has already been taken")
      end
    end

    context "when the order_in_trick isn't unique within a trick" do
      let(:order_in_trick) { 1 }

      before do
        round.cards.create!(rank: Card.ranks.keys.last, suit: suit, order_in_trick: order_in_trick)
        card.valid?
      end

      it { is_expected.to be_invalid }

      it "sets a 'has already been taken' error" do
        expect(card.errors[:order_in_trick]).to include("has already been taken")
      end
    end
  end
end
