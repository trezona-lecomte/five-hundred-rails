require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  let(:tricks)  { 6 }
  let(:suit)    { Suits::HEARTS }
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
      context "when the bid is a pass" do
        let(:tricks) { 0 }

        context "when the player is the first to bid" do
          it "adds a bid to the round" do
            expect{ SubmitBid.call(round, player1, tricks, suit) }.to change(Bid, :count).by(1)
          end
        end

        context "when other players have already bid" do
          before { round.bids.create!(tricks: 6, suit: suit, player: player1) }
          it "adds a bid to the round" do
            expect{ SubmitBid.call(round, player2, tricks, suit) }.to change(Bid, :count).by(1)
          end
        end
      end

      context "when the bid isn't a pass" do
        context "when the player is the first to bid" do
          it "adds a bid to the round" do
            expect{ SubmitBid.call(round, player1, tricks, suit) }.to change(Bid, :count).by(1)
          end
        end

        context "when it is another players turn to bid" do
          before { round.bids.create!(tricks: tricks, suit: suit, player: player1) }

          it "adds a bid to the round" do
            expect{ SubmitBid.call(round, player2, tricks + 1, suit) }.to change(Bid, :count).by(1)
          end
        end

        context "when it is the first players turn to bid again" do
          before { round.bids.create!(tricks: tricks, suit: suit, player: player4) }

          it "adds a bid to the round" do
            expect{ SubmitBid.call(round, player1, tricks, Suits::NO_TRUMPS) }.to change(Bid, :count).by(1)
          end
        end
      end
    end

    context "when the bid is unsuccessful" do
      context "when the bid is a pass" do
        context "when it is not the players turn" do
          before { round.bids.create!(tricks: tricks, suit: suit, player: player2) }

          it "doesn't create a bid" do
            [player1, player2, player4].each do |player|
              expect{ SubmitBid.call(round, player, 0, suit) }.to_not change(Bid, :count)
            end
          end

          it "raises an error on the player" do
            SubmitBid.call(round, player2, 0, suit)

            expect(player2.errors.messages[:bids].first).to include("not your turn")
          end
        end

        context "when the player has already passed" do
          before do
            round.bids.create!(tricks:      0, suit: suit, player: player1)
            round.bids.create!(tricks: tricks, suit: suit, player: player2)
            round.bids.create!(tricks: tricks, suit: suit, player: player3)
            round.bids.create!(tricks: tricks, suit: suit, player: player4)
          end

          it "doesn't create a bid" do
            expect{ SubmitBid.call(round, player1, 0, suit) }.to_not change(Bid, :count)
          end

          it "raises an error on the player" do
            SubmitBid.call(round, player2, 0, suit)

            expect(player2.errors.messages[:bids].first).to include("not your turn")
          end
        end
      end

      context "when the bid isn't a pass" do
        context "when it is not the players turn" do
          before { round.bids.create!(tricks: tricks, suit: suit, player: player2) }

          it "doesn't create a bid" do
            [player1, player2, player4].each do |player|
              expect{ SubmitBid.call(round, player, tricks, suit) }.to_not change(Bid, :count)
            end
          end

          it "raises an error on the player" do
            SubmitBid.call(round, player2, tricks, suit)

            expect(player2.errors.messages[:bids].first).to include("not your turn")
          end
        end

        context "when the bid number of tricks is too low" do
          before { round.bids.create!(tricks: 7, suit: suit, player: player1) }

          it "doesn't create a bid" do
            expect{ SubmitBid.call(round, player2, 6, suit: suit) }.to_not change(Bid, :count)
          end

          it "raises an error on the player" do
            SubmitBid.call(round, player2, 6, suit)

            expect(player2.errors.messages[:bids].first).to include("was too low")
          end
        end

        context "when the bid suit is too low" do
          before { round.bids.create!(tricks: 9, suit: Suits::NO_TRUMPS, player: player1) }

          it "doesn't create a bid" do
            expect{ SubmitBid.call(round, player2, 9, suit: Suits::HEARTS) }.to_not change(Bid, :count)
          end

          it "raises an error on the player" do
            SubmitBid.call(round, player2, 9, Suits::NO_TRUMPS)

            expect(player2.errors.messages[:bids].first).to include("was too low")
          end
        end
      end
    end
  end
end