require 'rails_helper'

RSpec.describe DealCards, type: :service do
  let(:game)  { Game.create! }
  let(:round) { game.rounds.create! }
  let(:deck)  { BuildDeck.new.call }

  describe "#call" do
    before { DealCards.new.call(round: round, deck: deck) }

    context "when the dealing is successful" do\
      it "deals 10 cards to each player" do
        round.hands.each do |hand|
          expect(hand.cards.count).to eq(10)
        end
      end

      it "deals the remaining cards to the kitty" do
        expect(round.kitty.cards.count).to eq(3)
      end
    end
  end
end
