require "rails_helper"

RSpec.describe SubmitBid, type: :service do
  fixtures :all

  let(:suit)             { Suits::NO_SUIT }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { Bid::PASS_TRICKS }
  let(:service_args)     { [round, player, number_of_tricks, suit] }
  let(:service)          { SubmitBid.new(*service_args) }

  BIDDING_IS_FINISHED_ERROR = "bidding for this round has finished"
  NOT_PLAYERS_TURN_ERROR    = "it's not your turn to bid"
  PLAYER_HAS_PASSED_ERROR   = "you have already passed during this round"

  describe "#bidding_is_open" do
    subject { service }

    before { service.valid? }

    context "when the round is finished" do
      let(:round) { rounds(:finished_round) }

      it { is_expected.to be_invalid }

      it "has the correct 'round has finished' error" do
        expect(service.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
      end
    end

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      it { is_expected.to be_invalid }

      it "has the correct 'round has finished' error" do
        expect(service.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
      end
    end

    context "when the round is in the bidding stage" do
      it { is_expected.to be_valid }
    end
  end

  describe "#call" do
    context "when no bids have been made" do
      context "when the first player bids" do
        it "submits the bid" do
          expect { service.call }.to change(Bid, :count).by(1)
          expect(round.bids).to be_one
        end
      end

      context "when anyone but the first player bids" do
        context "when the second player bids" do
          let(:player) { players(:bidder2) }

          it "doesn't submit the bid" do
            expect { service.call }.to_not change(Bid, :count)
          end

          it "sets a 'not your turn' error" do
            service.call

            expect(service.errors[:base]).to include("it's not your turn to bid")
          end
        end

        context "when the third player bids" do
          let(:player) { players(:bidder3) }

          it "doesn't submit the bid" do
            expect{ service.call }.to_not change(Bid, :count)
          end

          it "sets a 'not your turn' error" do
            service.call

            expect(service.errors[:base]).to include("it's not your turn to bid")
          end
        end
        context "when the fourth player bids" do
          let(:player) { players(:bidder4) }

          it "doesn't submit the bid" do
            expect{ service.call }.to_not change(Bid, :count)
          end

          it "sets a 'not your turn' error" do
            service.call

            expect(service.errors[:base]).to include("it's not your turn to bid")
          end
        end
      end
    end
  end
end
