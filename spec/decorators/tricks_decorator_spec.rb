require "rails_helper"

RSpec.describe TricksDecorator, type: :decorator do
  fixtures :all
  let(:round)      { rounds(:playing_round) }
  let(:base_trick) { round.tricks.order(number_in_round: :asc).first }
  let(:trick)      { TricksDecorator.new(base_trick) }
  let(:player)     { players(:player2) }
  let(:card)       { cards(:jack_of_hearts) }

  describe "#last_played_card" do
    subject { trick.last_played_card }

    context "when no cards have been played" do
      it { is_expected.to be nil }
    end

    context "when a single card has been played" do
      before { PlayCard.new(base_trick, player, card).call }

      it { is_expected.to eq(card) }
    end

    context "when multiple cards have been played" do
      before do
        PlayCard.new(base_trick, player, card).call
        PlayCard.new(base_trick, players(:player3), cards(:nine_of_diamonds)).call
        PlayCard.new(base_trick, players(:player4), cards(:six_of_hearts)).call
      end

      it { is_expected.to eq(cards(:six_of_hearts)) }
    end
  end

  describe "#winning_card" do
    subject { trick.winning_card }

    context "when no cards have been played on the trick" do
      it { is_expected.to be_nil }
    end

    context "when a single card has been played" do
      before do
        PlayCard.new(base_trick, player, card).call
      end

      it { is_expected.to eq(card) }
    end

    context "when multiple cards have been played" do
      before do
        PlayCard.new(base_trick, player, card).call
        PlayCard.new(base_trick, players(:player3), cards(:nine_of_hearts)).call
      end

      it { is_expected.to eq(card) }
    end
  end
end
