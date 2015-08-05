require "rails_helper"

RSpec.describe PlayCard, type: :service do
  fixtures :all
  let(:game)      { games(:playing_game) }
  let(:round)     { rounds(:playing_round) }
  # TODO: we're assuming (for now) that player 2 won the bidding:
  let(:player)    { players(:player2) }
  let(:card)      { cards(:jack_of_hearts) }
  let(:play_card) { PlayCard.new(round, player, card) }

  describe "#call" do
    context "when it is the first trick" do
      context "when no cards have been played yet" do
        before { play_card.call }

        context "when the bid-winner attempts to play a card" do
          it "plays the card" do
            expect(card.trick).to eq(round.tricks.first)
          end

          it "doesn't set any errors" do
            expect(play_card.errors).to be_empty
          end
        end

        context "when a non-winning bidder attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:king_of_hearts) }

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "sets a 'not your turn' error" do
            expect(play_card.errors).to include("it's not your turn to play")
          end
        end
      end

      context "when cards have been played" do
        before do
          PlayCard.new(round, players(:player2), cards(:nine_of_clubs)).call
          PlayCard.new(round, players(:player3), cards(:seven_of_clubs)).call

          play_card.call
        end

        context "when the correct player attempts to play" do
          let(:player) { players(:player4) }
          let(:card)   { cards(:five_of_clubs) }

          it "plays the card" do
            expect(card.trick).to eq(round.tricks.first)
          end

          it "doesn't set any errors" do
            expect(play_card.errors).to be_empty
          end
        end

        context "when an incorrect player attempts to play" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:queen_of_clubs) }

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "doesn't set any errors" do
            expect(play_card.errors).to include("it's not your turn to play")
          end
        end
      end
    end

    context "when it isn't the first trick" do
      before do
        PlayCard.new(round, players(:player2), cards(:ten_of_hearts)).call
        PlayCard.new(round, players(:player3), cards(:nine_of_hearts)).call
        PlayCard.new(round, players(:player4), cards(:six_of_hearts)).call
        PlayCard.new(round, players(:player1), cards(:king_of_hearts)).call
      end

      context "when no cards have been played into this trick" do
        context "when the last trick winner attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:king_of_diamonds) }

          before do
            play_card.call
          end

          it "plays the card" do
            expect(card.trick).to eq(round.tricks.last)
          end

          it "doesn't set any errors" do
            expect(play_card.errors).to be_empty
          end
        end

        context "when an incorrect player attempts to play a card" do
          let(:player)    { players(:player2) }
          let(:card)      { cards(:jack_of_clubs)}

          before do
            play_card.call
          end

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "sets the error to 'not your turn'" do
            expect(play_card.errors).to include("it's not your turn to play")
          end
        end
      end

      context "when cards have been played into this trick" do
        before do
          PlayCard.new(round, players(:player1), cards(:ace_of_diamonds)).call

          play_card.call
        end

        context "when the correct player attempts to play a card" do
          let(:player) { players(:player2) }
          let(:card)   { cards(:ten_of_diamonds) }

          it "plays the card" do
            expect(card.trick).to eq(round.tricks.last)
          end

          it "doesn't set any errors" do
            expect(play_card.errors).to be_empty
          end
        end

        context "when an incorrect player attempts to play a card" do
          let(:player) { players(:player3) }
          let(:card)   { cards(:nine_of_diamonds) }

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "sets the error to 'not your turn'" do
            expect(play_card.errors).to include("it's not your turn to play")
          end
        end
      end
    end
  end
end
