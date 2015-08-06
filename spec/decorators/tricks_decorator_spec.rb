require "rails_helper"

RSpec.describe TricksDecorator, type: :decorator do
  fixtures :all
  let(:round)      { rounds(:playing_round) }
  let(:base_trick) { round.tricks.first }
  let(:trick)      { TricksDecorator.new(base_trick) }
  let(:player)     { players(:player2) }
  let(:card)       { cards(:jack_of_hearts) }

  describe "#winning_card" do
    subject { trick.winning_card }

    context "when no cards have been played on the trick" do
      it { is_expected.to be_nil }
    end

    context "when a single card has been played" do
      before { PlayCard.new(round, player, card).call }

      it { is_expected.to eq(card) }
    end

    context "when multiple cards have been played" do
      before do
        PlayCard.new(round, player, card).call
        PlayCard.new(round, players(:player3), cards(:nine_of_hearts)).call
      end

      it { is_expected.to eq(card) }
    end
  end
end
