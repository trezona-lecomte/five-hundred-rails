require "rails_helper"

describe DealCards, type: :service do
  fixtures :all
  let(:game)       { Game.create! }
  let(:base_round) { game.rounds.create!(odd_players_score: 0,
                                         even_players_score: 0,
                                         order_in_game: 0) }
  let(:round)      { base_round }
  let(:deck)       { BuildDeck.new.call }
  let(:fresh_deck) { BuildDeck.new.call }
  let(:deal_cards) { DealCards.new(base_round, deck) }
  let(:players)    { game.players }

  before { 4.times { |n| JoinGame.new(game: game, user: users("user#{n+1}")).call } }

  describe "#call" do
    before { deal_cards.call }

    context "when the dealing is successful" do
      it "deals all the cards into the round" do
        expect(round.cards.count).to eq(fresh_deck.count)
      end

      it "deals 10 cards to each player" do
        game.players.each do |player|
          expect(player.cards.count).to eq(Game::HAND_SIZE)
        end
      end

      it "leaves 3 cards without a player" do
        expect(round.cards.where(player: nil).count).to eq(3)
      end
    end
  end
end
