require "rails_helper"

RSpec.describe ScoreRound, type: :service do
  fixtures :all

  let(:game)        { games(:playing_game) }
  let(:base_round)  { rounds(:finished_round) }
  let(:score_round) { ScoreRound.new(base_round) }

  describe "#call" do
    context "when the round has finished" do
      let(:round) { score_round.round }

      context "when the odd team attacked" do
        context "and won with a bid of 7 hearts" do
          before { score_round.call }

          it "sets the odd team score to 200" do
            expect(round.odd_players_score).to eq(200)
          end

          it "sets the even team score to 0" do
            expect(round.even_players_score).to eq(0)
          end
        end

        context "and lost with a bid of 6 no trumps" do
          # TODO try to extract round.bids.create! to a let! { } - this is a before before.
          before do
            allow(score_round).to receive(:tricks_for).and_return(round.tricks.first(5), round.tricks.last(5))
            allow(round).to receive(:highest_bid).and_return(round.bids.create!(player: players(:player3),
                                                                                number_of_tricks: 6,
                                                                                suit: Card.suits[:no_suit],
                                                                                order_in_round: round.bids.count + 1))
            score_round.call
          end

          it "sets the odd team score to -120" do
            expect(round.odd_players_score).to eq(-120)
          end

          it "sets the even team score to 50" do
            expect(round.even_players_score).to eq(50)
          end
        end
      end

      context "when the even team attacked" do
        context "and won with a bid of 6 spades" do
          before do
            allow(score_round).to receive(:tricks_for).and_return(round.tricks.first(8), round.tricks.last(2))
            allow(round).to receive(:highest_bid).and_return(round.bids.create!(player: players(:player2),
                                                                                number_of_tricks: 6,
                                                                                suit: Card.suits[:spades],
                                                                                order_in_round: round.bids.count + 1))
            score_round.call
          end

          it "sets the even team score to 40" do
            expect(round.even_players_score).to eq(40)
          end

          it "sets the odd team score to 20" do
            expect(round.odd_players_score).to eq(20)
          end
        end

        context "and lost with a bid of 9 diamonds" do
          before do
            allow(score_round).to receive(:tricks_for).and_return(round.tricks.first(8), round.tricks.last(2))
            allow(round).to receive(:highest_bid).and_return(round.bids.create!(player: players(:player4),
                                                                                number_of_tricks: 9,
                                                                                suit: Card.suits[:diamonds],
                                                                                order_in_round: round.bids.count + 1))
            score_round.call
          end

          it "sets the even team score to -380" do
            expect(round.even_players_score).to eq(-380)
          end

          it "sets the odd team score to 20" do
            expect(round.odd_players_score).to eq(20)
          end
        end
      end


    end

    context "when the round hasn't yet finished" do

    end
  end
end
