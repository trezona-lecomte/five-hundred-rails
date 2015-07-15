require 'rails_helper'

RSpec.describe DealRound, type: :service do
  let(:game)  { CreateGame.new.call }

  describe "#call" do
    before do
      DealRound.new(game: game).call
    end

    context "when the dealing is successful" do
      let(:round) { game.rounds.first }

      it "deals 10 cards to each player" do
        round.hands.each do |hand|
          expect(hand.playing_cards.count).to eq(10)
        end
      end

      it "deals the remaining cards to the kitty" do
        expect(round.kitty.playing_cards.count).to eq(3)
      end
    end

    context "when the card dealing is unsuccessful" do
      pending "negative tests"
    end
  end
end
