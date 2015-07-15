require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  fixtures :all
  let(:round)   { rounds(:bidding_round) }
  let(:player1) { players(:bidding_player_1) }
  let(:player2) { players(:bidding_player_2) }
  let(:player3) { players(:bidding_player_3) }
  let(:player4) { players(:bidding_player_4) }
  let(:bid_submitter)   { SubmitBid.new(round, player) }
  let(:suit)    { Suits::HEARTS }
  let(:tricks)  { 6 }

  describe "#call" do
    subject(:submit_bid) { bid_submitter.call(tricks, suit) }

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
      let(:not_turn_error)     { "It's not your turn to bid." }
      let(:bid_too_low_error)  { "Your last bid was too low." }

      context "when the bid is a pass" do
        let(:tricks) { 0 }

        context "when it is not the players turn" do
          let(:bid_submitter) { SubmitBid.new(round, player2) }

          it "doesn't create a bid" do
              expect{ bid_submitter.call(tricks, suit) }.to_not change(Bid, :count)
          end

          before { submit_bid }

          it "stores a 'not your turn' error" do
              expect(bid_submitter.error).to eq(not_turn_error)
          end
        end

        context "when the player has already passed" do
          before do
            round.bids.create!(tricks: tricks, suit: suit, player: player)

            [player2, player3, player4].each_with_index do |player, index|
              round.bids.create!(tricks: 6 + index, suit: suit, player: player)
            end
          end

          it "doesn't create a bid" do
            expect{ submit_bid }.to_not change(Bid, :count)
          end

          before { submit_bid }

          it "stores a 'not your turn' error" do
            expect(bid_submitter.error).to eq(not_turn_error)
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

          it "stores a 'not your turn' error" do
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

          it "stores a 'bid too low' error" do
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

          it "stores a 'bid too low' error" do
            submit_bid = SubmitBid.new(round, player)
            submit_bid.call(tricks, Suits::NO_TRUMPS)

            expect(submit_bid.error).to eq(bid_too_low_error)
          end
        end
      end
    end
  end
end
