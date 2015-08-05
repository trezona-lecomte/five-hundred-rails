require "rails_helper"

RSpec.describe TricksDecorator, type: :decorator do
  let(:game)            { Game.create! }
  let(:round)           { game.rounds.first }
  let(:trick)           { round.tricks.first }
  let(:decorated_trick) { TricksDecorator.new(trick) }
  let(:card1)           { round.cards.where(rank: 14, suit: 3).first }
  let(:card2)           { round.cards.where(rank:  4, suit: 3).first }

  before do
    4.times { JoinGame.new(game, Faker::Internet.user_name).call }
    start_round = StartRound.new(game)
    start_round.call
    round = start_round.round
    DealCards.new(game, round, BuildDeck.new.call).call
  end

  describe "#winning_card" do
    subject { decorated_trick.winning_card }

    context "when no cards have been played on the trick" do
      it { is_expected.to be_nil }
    end

    context "when a single card has been played" do
      before { PlayCard.new(round, card1.player, card1).call }

      it { is_expected.to eq(card1) }
    end

    context "when multiple cards have been played" do
      before do
        PlayCard.new(round, card1.player, card1)
        PlayCard.new(round, card2.player, card2)
      end

      it { is_expected.to eq(card2) }
    end
  end
end
