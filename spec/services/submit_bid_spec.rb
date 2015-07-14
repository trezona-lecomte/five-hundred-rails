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
  let(:players) { [player1, player2, player3, player4] }
  let(:not_turn_error)       { "It's not your turn to bid." }
  let(:bid_too_low_error)    { "Your last bid was too low." }
  let(:bidding_over_error)   { "Bidding for this round has finished." }

  before do
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.first)
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.first)
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.last)
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.last)

    deck = BuildDeck.new.call
    DealRound.new.call(game, deck, [11, 21, 12, 22])
  end

  describe "#call" do
    subject(:submit_bid) { SubmitBid.new(round, player).call(tricks, suit) }

    let(:player) { player1 }

    context "when the bid is successful" do
      context "when the bid is a pass" do
        let(:tricks) { 0 }

        context "when the player is the first to bid" do
          it "adds a bid to the round" do
            expect{ submit_bid }.to change(Bid, :count).by(1)
          end
        end

        context "when other players have already bid" do
          before { round.bids.create!(tricks: 6, suit: suit, player: player4) }

          it "adds a bid to the round" do
            expect{ submit_bid }.to change(Bid, :count).by(1)
          end
        end
      end

      context "when the bid isn't a pass" do
        let(:tricks) { 7 }

        context "when the player is the first to bid" do
          it "adds a bid to the round" do
            expect{ submit_bid }.to change(Bid, :count).by(1)
          end
        end

        context "when other players have already bid" do
          let(:player) { player4 }

          before { round.bids.create!(tricks: 6, suit: suit, player: player3) }

          it "adds a bid to the round" do
            expect{ submit_bid }.to change(Bid, :count).by(1)
          end
        end

        context "when it is the first players turn to bid again after a full round of bidding" do
          before do
            players.each_with_index do |player, index|
              round.bids.create!(tricks: 6 + index, suit: suit, player: player)
            end
          end

          let(:tricks) { 10 }

          it "adds a bid to the round" do
            expect{ submit_bid }.to change(Bid, :count).by(1)
          end
        end
      end
    end

    context "when the bid is unsuccessful" do
      context "when the bid is a pass" do
        let(:tricks) { 0 }

        context "when it is not the players turn" do
          before { round.bids.create!(tricks: 0, suit: suit, player: player2) }

          it "doesn't create a bid" do
            [player1, player2, player4].each do |player|
              expect{ submit_bid }.to_not change(Bid, :count)
            end
          end

          it "raises a 'not your turn' error" do
            submit_bid = SubmitBid.new(round, player2)
            submit_bid.call(0, suit)

            expect(submit_bid.error).to eq(not_turn_error)
          end
        end

        context "when the player has already passed" do
          let(:tricks) { 0 }

          before do
            round.bids.create!(tricks: tricks, suit: suit, player: player1)

            [player2, player3, player4].each_with_index do |player, index|
              round.bids.create!(tricks: 6 + index, suit: suit, player: player)
            end
          end

          it "doesn't create a bid" do
            expect{ submit_bid }.to_not change(Bid, :count)
          end

          it "raises a 'not your turn' error" do
            submit_bid = SubmitBid.new(round, player1)
            submit_bid.call(tricks, suit)

            expect(submit_bid.error).to eq(not_turn_error)
          end
        end
      end

      context "when the bid isn't a pass" do
        context "when it is not the players turn" do
          before { round.bids.create!(tricks: tricks, suit: suit, player: player2) }

          it "doesn't create a bid" do
            [player1, player2, player4].each do |player|
              expect{ submit_bid }.to_not change(Bid, :count)
            end
          end

          it "raises a 'not your turn' error" do
            submit_bid = SubmitBid.new(round, player2)
            submit_bid.call(tricks, suit)

            expect(submit_bid.error).to eq(not_turn_error)
          end
        end

        context "when the bid number of tricks is too low" do
          let(:tricks) { 6 }

          before { round.bids.create!(tricks: tricks + 1, suit: suit, player: player4) }

          it "doesn't create a bid" do
            expect{ submit_bid }.to_not change(Bid, :count)
          end

          it "raises a 'bid too low' error" do
            submit_bid = SubmitBid.new(round, player)
            submit_bid.call(tricks, suit)

            expect(submit_bid.error).to eq(bid_too_low_error)
          end
        end

        context "when the bid suit is too low" do
          let(:tricks) { 9 }

          before { round.bids.create!(tricks: tricks, suit: Suits::NO_TRUMPS, player: player4) }

          it "doesn't create a bid" do
            expect{ submit_bid }.to_not change(Bid, :count)
          end

          it "raises a 'bid too low' error" do
            submit_bid = SubmitBid.new(round, player)
            submit_bid.call(tricks, Suits::NO_TRUMPS)

            expect(submit_bid.error).to eq(bid_too_low_error)
          end
        end
      end
    end
  end
end
