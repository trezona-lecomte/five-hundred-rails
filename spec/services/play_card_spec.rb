require "rails_helper"

RSpec.describe PlayCard, type: :service do
  let(:game)  { Game.create! }
  let(:round) { game.rounds.first }
  let(:player) { game.players.first }
  let(:card)   { player.cards.first }

  before do
    4.times { JoinGame.new(game, Faker::Internet.user_name).call }
    start_round = StartRound.new(game)
    start_round.call
    round = start_round.round
    DealCards.new(game, round, BuildDeck.new.call).call
  end

  describe "#call" do
    before { PlayCard.new(round, player, card).call }

    context "when it is the first round" do
      context "when it is the first trick" do
        context "when player 1 attempts to play a card" do
          let(:player) { game.players.first }

          it "adds the card to the trick" do
            expect(card.trick).to eq(round.tricks.first)
          end
        end

        context "when player 2 attempts to play a card" do
          let(:player) { game.players.first(2).last }

          it "doesn't add the card to the trick" do
            expect(card.trick).to be_nil
          end

        end
      end

      context "when it isn't the first trick" do

      end
    end

    context "when it isn't the first round" do

    end
  end

  context "when the card can't be played" do

  end
end
