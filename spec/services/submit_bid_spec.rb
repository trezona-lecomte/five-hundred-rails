require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  let(:number)  { 6 }
  let(:suit)    { "hearts" }
  let(:game)    { CreateGame.new.call }
  let(:round)   { game.rounds.first }
  let(:player1) { game.teams.first.players.first }
  let(:player2) { game.teams.last.players.first }
  let(:player3) { game.teams.first.players.last }
  let(:player4) { game.teams.last.players.last }
  let(:users)   { [User.create!(username: "kieran"),
                   User.create!(username: "pragya"),
                   User.create!(username: "mitchy"),
                   User.create!(username: "mickee")] }

  before do
    JoinTeam.new.call(users[0], game.teams.first)
    JoinTeam.new.call(users[1], game.teams.first)
    JoinTeam.new.call(users[2], game.teams.last)
    JoinTeam.new.call(users[3], game.teams.last)

    deck = BuildDeck.new.call
    DealRound.new.call(game, deck, [11, 21, 12, 22])
  end

  describe "#call" do
    context "when the bid is successful" do
      context "when the player is the first to bid" do
        it "adds an action to the round" do
          expect{ SubmitBid.call(round, player1, number, suit) }.to change(Action, :count).by(1)
        end
      end

      context "when it is another players turn to bid" do
        before { round.actions.create!(action_type: Action::BID, action_value: "6H", player: player1) }

        it "adds an action to the round" do
          expect{ SubmitBid.call(round, player2, number, suit) }.to change(Action, :count).by(1)
        end
      end

      context "when it is the first players turn to bid again" do
        before { round.actions.create!(action_type: Action::BID, action_value: "6H", player: player4) }

        it "adds an action to the round" do
          expect{ SubmitBid.call(round, player1, number, suit) }.to change(Action, :count).by(1)
        end
      end
    end

    context "when the bid is unsuccessful" do
      context "when it is not the players turn" do
        before { round.actions.create!(action_type: Action::BID, action_value: "6H", player: player2) }

        it "doesn't create an action" do
          [player1, player2, player4].each do |player|
            expect{ SubmitBid.call(round, player, number, suit) }.to_not change(Action, :count)
          end
        end

        it "raises an error on the player" do
          SubmitBid.call(round, player2, number, suit)

          expect(player2).to have(1).error
        end
      end
    end
  end
end