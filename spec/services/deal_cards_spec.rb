require "rails_helper"

RSpec.describe DealCards, type: :service do
  fixtures :all
  let(:game)       { Game.create! }
  let(:base_round) { game.rounds.create! }
  let(:round)      { RoundsDecorator.new(base_round) }
  let(:deck)       { BuildDeck.new.call }
  let(:fresh_deck) { BuildDeck.new.call }
  let(:deal_cards) { DealCards.new(game, base_round, deck) }
  let(:players)    { game.players }

  before { 4.times { |n| JoinGame.new(game, users("user#{n+1}")).call } }

  describe "#call" do
    before { deal_cards.call }

    context "when the dealing is successful" do
      it "deals all the cards into the round" do
        expect(round.cards.count).to eq(fresh_deck.count)
      end

      it "deals 10 cards to each player" do
        game.players.each do |player|
          expect(player.cards.count).to eq(10)
        end
      end

      it "deals the cards into 4 'hands'" do
        expect(round.hands.count).to eq(4)

        round.hands.each do |hand|
          expect(players).to include(hand[0])

          expect(hand[1].count).to eq(10)
        end
      end

      it "deals 3 cards into the kitty" do
        expect(players).to_not include(round.kitty[0])

        expect(round.kitty.count).to eq(3)
      end
    end
  end
end
