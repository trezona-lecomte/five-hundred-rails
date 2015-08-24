# TODO: add negative tests for bids having to be higher
require "rails_helper"

class Validatable
  include ActiveModel::Model
  include ActiveModel::Validations
  validates_with BidSubmissionValidator

  attr_accessor :round, :player, :number_of_tricks, :suit
end

BIDDING_IS_FINISHED_ERROR = "bidding for this round has finished"
NOT_PLAYERS_TURN_ERROR    = "it's not your turn to bid"
PLAYER_HAS_PASSED_ERROR   = "you have already passed during this round"

RSpec.describe BidSubmissionValidator, type: :validator do
  fixtures :all

  let(:suit)             { Suits::NO_SUIT }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { Bid::PASS_TRICKS }

  subject(:validatable) { Validatable.new(suit: suit,
                                          round: round,
                                          player: player,
                                          number_of_tricks: number_of_tricks) }

  context "when the round is not in the bidding stage" do
    let(:round) { rounds(:playing_round) }

    before { validatable.valid? }

    it { is_expected.to be_invalid }

    it "has the correct 'round has finished' error" do
      expect(validatable.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
    end
  end

  context "when it is the first bid of the round" do
    context "when the correct player tries to bid" do
      it { is_expected.to be_valid }
    end

    context "when the incorrect player tries to bid" do
      3.times do |n|
        let(:player) { players("bidder#{n + 1}") }

        before { validatable.valid? }

        it { is_expected.to be_invalid }

        it "has the correct 'not your turn' error" do
          expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
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

          before { validatable.valid? }

          it { is_expected.to be_invalid }

          it "has the correct 'not your turn' error" do
            expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
          end
        end
      end
    end

    context "when the first player didn't pass" do
      before { round.bids.create!(player: players(:bidder1), number_of_tricks: 6, suit: Suits::HEARTS) }

      context "when the second player tries to bid" do
        let(:player) { players(:bidder2) }

        it { is_expected.to be_valid }
      end

      3.times do |n|
        context "when an incorrect player tries to bid" do
          let(:player) { n.zero? ? players(:bidder1) : players("bidder#{n + 2}") }

          before { validatable.valid? }

          it { is_expected.to be_invalid }

          it "has the correct 'not your turn' error" do
            expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
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
          round.bids.create!(player: players(:bidder1), number_of_tricks: 6, suit: Suits::HEARTS)
          round.bids.passes.create!(player: players(:bidder2))
        end

        context "when the third player tries to bid" do
          let(:player) { players(:bidder3) }

          it { is_expected.to be_valid }
        end

        3.times do |n|
          context "when an incorrect player tries to bid" do
            let(:player) { n == 2 ? players(:bidder4) : players("bidder#{n + 1}") }

            before { validatable.valid? }

            it { is_expected.to be_invalid }

            it "has the correct 'not your turn' error" do
              expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
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
          before { round.bids.create!(player: players(:bidder3), number_of_tricks: 7, suit: Suits::SPADES) }

          context "when the fourth player tries to bid" do
            let(:player) { players(:bidder4) }

            it { is_expected.to be_valid }
          end

          3.times do |n|
            context "when an incorrect player tries to bid" do
              let(:player) { players("bidder#{n + 1}") }

              before { validatable.valid? }

              it { is_expected.to be_invalid }

              it "has the correct 'not your turn' error" do
                expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
              end
            end
          end
        end

        context "and the third player passed" do
          before { round.bids.passes.create!(player: players(:bidder3)) }

          context "when any of the players try to bid" do
            4.times do |n|
              let(:player) { players("bidder#{n + 1}") }

              before { validatable.valid? }

              it { is_expected.to be_invalid }

              it "has the correct 'bidding has finished' error" do
                expect(validatable.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
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
      before { round.bids.create!(player: players(:bidder1), number_of_tricks: 6, suit: Suits::HEARTS) }

      context "and the second player passed" do
        before { round.bids.passes.create!(player: players(:bidder2)) }

        context "and the third player didn't pass" do
          before { round.bids.create!(player: players(:bidder3), number_of_tricks: 7, suit: Suits::SPADES) }

          context "and the fourth player passed" do
            before { round.bids.passes.create!(player: players(:bidder4)) }

            context "when the first player tries to bid" do
              let(:player) { players(:bidder1) }

              it { is_expected.to be_valid }
            end

            context "when the incorrect player tries to bid" do
              3.times do |n|
                let(:player) { players("bidder#{n + 1}") }

                before { validatable.valid? }

                it { is_expected.to be_invalid }

                it "has the correct 'not your turn' error" do
                  expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
                end
              end
            end
          end

          context "and the fourth player didn't pass" do
            before { round.bids.create!(player: players(:bidder4), number_of_tricks: 7, suit: Suits::CLUBS) }

            context "when the first player tries to bid" do
              let(:player) { players(:bidder1) }

              it { is_expected.to be_valid }
            end

            context "when the incorrect player tries to bid" do
              3.times do |n|
                let(:player) { players("bidder#{n + 1}") }

                before { validatable.valid? }

                it { is_expected.to be_invalid }

                it "has the correct 'not your turn' error" do
                  expect(validatable.errors[:base]).to include(NOT_PLAYERS_TURN_ERROR)
                end
              end
            end
          end
        end
      end
    end
  end
end
