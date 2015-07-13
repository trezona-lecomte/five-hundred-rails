require 'rails_helper'

RSpec.describe DealRound, type: :service do
  let(:game)  { CreateGame.new.call }
  let(:deck)  { BuildDeck.new.call }

  describe "#call" do
    before do
      DealRound.new.call(game, deck, [11, 21, 12, 22])
    end

    context "when the dealing is successful" do
      let(:round) { game.rounds.first }

      it "deals 10 cards to each player" do
        round.hands.each do |hand|
          expect(hand.cards.count).to eq(10)
        end
      end

      it "deals the remaining cards to the kitty" do
        expect(round.kitty.cards.count).to eq(3)
      end
    end

    context "when the card dealing is unsuccessful" do
      pending "negative tests"
    end
  end
end
