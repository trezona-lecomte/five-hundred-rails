require "rails_helper"

RSpec.describe BidderIsNextInOrderValidator, type: :validator do
  fixtures :all

  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:pass)             { false }
  let(:suit)             { Suits::NO_SUIT }
  let(:number_of_tricks) { Bid::MIN_TRICKS }

  subject(:bid) {
    Bid.new(
      round: round,
      player: player,
      pass: pass,
      number_of_tricks: number_of_tricks,
      suit: suit
    )
  }

  BIDDING_FINISHED_ERROR     = "bidding for this round has finished"
  NOT_YOUR_TURN_TO_BID_ERROR = "it's not your turn to bid"
  PLAYER_HAS_PASSED_ERROR    = "you have already passed during this round"

  context "when it is the first bid of the round" do
    context "when the correct player tries to bid" do
      it { is_expected.to be_valid }
    end

    context "when the incorrect player tries to bid" do
      3.times do |n|
        let(:player) { players("bidder#{n + 1}") }

        before { bid.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'not your turn' error" do
          expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
        end
      end
    end
  end

  context "when it is the second bid of the round" do
    context "when the first player passed" do
      before { round.bids.passes.create!(player: players(:bidder1)) }

      context "when the second player tries to bid" do
        let(:player) { players(:bidder2) }

        it { is_expected.to be_valid }
      end

      3.times do |n|
        context "when an incorrect player tries to bid" do
          let(:player) { n.zero? ? players(:bidder1) : players("bidder#{n + 2}") }

          before { bid.valid? }

          it { is_expected.to be_invalid }

          it "has the correct 'not your turn' error" do
            expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
          end
        end
      end
    end

    context "when the first player didn't pass" do
      before { round.bids.non_passes.create!(player: players(:bidder1), number_of_tricks: 6, suit: Suits::HEARTS) }

      context "when the second player tries to bid" do
        let(:player) { players(:bidder2) }

        it { is_expected.to be_valid }
      end

      3.times do |n|
        context "when an incorrect player tries to bid" do
          let(:player) { n.zero? ? players(:bidder1) : players("bidder#{n + 2}") }

          before { bid.valid? }

          it { is_expected.to be_invalid }

          it "has the correct 'not your turn' error" do
            expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
          end
        end
      end
    end
  end

  context "when is the third bid of the round" do
    let(:round) { rounds(:bidding_round) }

    context "when the first player didn't pass" do
      context "and the second player passed" do
        before do
          bid1 = round.bids.non_passes.new(player: players(:bidder1), number_of_tricks: 6, suit: Suits::HEARTS)
          bid1.save!
          bid2 = round.bids.passes.new(player: players(:bidder2))
          bid2.save!
        end

        context "when the third player tries to bid" do
          let(:player) { players(:bidder3) }

          it { is_expected.to be_valid }
        end

        3.times do |n|
          context "when an incorrect player tries to bid" do
            let(:player) { n == 2 ? players(:bidder4) : players("bidder#{n + 1}") }

            before { bid.valid? }

            it { is_expected.to be_invalid }

            it "has the correct 'not your turn' error" do
              expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
            end
          end
        end
      end
    end
  end

  context "when is the fourth bid of the round" do
    let(:round) { rounds(:bidding_round) }

    context "when the first player passed" do
      before { round.bids.passes.create!(player: players(:bidder1)) }

      context "and the second player passed" do
        before { round.bids.passes.create!(player: players(:bidder2)) }

        context "but the third player didn't pass" do
          before { round.bids.non_passes.new(player: players(:bidder3), number_of_tricks: 7, suit: Suits::SPADES).save! }

          context "when the fourth player tries to bid" do
            let(:player)           { players(:bidder4) }
            let(:number_of_tricks) { 8 }

            it do
              is_expected.to be_valid
            end
          end

          3.times do |n|
            context "when an incorrect player tries to bid" do
              let(:player) { players("bidder#{n + 1}") }
              let(:number_of_tricks) { 8 }

              before { bid.valid? }

              it { is_expected.to be_invalid }

              it "has the correct 'not your turn' error" do
                expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
              end
            end
          end
        end

        context "and the third player passed" do
          before { round.bids.passes.create!(player: players(:bidder3)) }

          context "when any of the players try to bid" do
            4.times do |n|
              let(:player) { players("bidder#{n + 1}") }

              before { bid.valid? }

              it { is_expected.to be_invalid }

              it "has the correct 'bidding has finished' error" do
                expect(bid.errors[:base]).to include(BIDDING_FINISHED_ERROR)
              end
            end
          end
        end
      end
    end
  end

  context "when is the fifth bid of the round" do
    let(:round) { rounds(:bidding_round) }

    context "when the first player didn't pass" do
      before { round.bids.non_passes.new(player: players(:bidder1), number_of_tricks: 6, suit: Suits::HEARTS).save! }

      context "and the second player passed" do
        before { round.bids.passes.new(player: players(:bidder2)).save! }

        context "and the third player didn't pass" do
          before { round.bids.non_passes.new(player: players(:bidder3), number_of_tricks: 7, suit: Suits::SPADES).save! }

          context "and the fourth player passed" do
            before { round.bids.passes.new(player: players(:bidder4)).save! }

            context "when the first player tries to bid" do
              let(:player)           { players(:bidder1) }
              let(:number_of_tricks) { 8 }

              it { is_expected.to be_valid }
            end

            context "when the incorrect player tries to bid" do
              3.times do |n|
                let(:player)           { players("bidder#{n + 1}") }
                let(:number_of_tricks) { 8 }

                before { bid.valid? }

                it { is_expected.to be_invalid }

                it "has the correct 'not your turn' error" do
                  expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
                end
              end
            end
          end

          context "and the fourth player didn't pass" do
            before { round.bids.non_passes.create!(player: players(:bidder4), number_of_tricks: 7, suit: Suits::CLUBS) }

            context "when the first player tries to bid" do
              let(:player)           { players(:bidder1) }
              let(:number_of_tricks) { 8 }

              it { is_expected.to be_valid }
            end

            context "when the incorrect player tries to bid" do
              3.times do |n|
                let(:player) { players("bidder#{n + 1}") }

                before { bid.valid? }

                it { is_expected.to be_invalid }

                it "has the correct 'not your turn' error" do
                  expect(bid.errors[:base]).to include(NOT_YOUR_TURN_TO_BID_ERROR)
                end
              end
            end
          end
        end
      end
    end
  end
end
