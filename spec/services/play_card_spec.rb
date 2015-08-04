require "rails_helper"

RSpec.describe PlayCard, type: :service do
  fixtures :all
  let(:game)  { games(:playing_game) }
  let(:round) { rounds(:playing_round) }
  # TODO: we're assuming (for now) that player 2 won the bidding:
  let(:player) { players(:player2) }
  let(:card)   { cards(:jack_of_hearts) }

  describe "#call" do
    before { PlayCard.new(round, player, card).call }

    context "when it is the first trick" do
      context "when the bid-winner attempts to play a card" do
        it "plays the card" do
          expect(card.trick).to eq(round.tricks.first)
        end
      end

      context "when a non-winning bidder attempts to play a card" do
        let(:player) { players(:player1) }
        let(:card)   { cards(:king_of_hearts) }

        it "doesn't play the card" do
          expect(card.trick).to be_nil
        end
        # TODO validate error message
      end
    end

    context "when it isn't the first trick" do
      before do
        PlayCard.new(round, players(:player2), cards(:ten_of_hearts)).call
        PlayCard.new(round, players(:player3), cards(:nine_of_hearts)).call
        PlayCard.new(round, players(:player4), cards(:six_of_hearts)).call
        PlayCard.new(round, players(:player1), cards(:king_of_hearts)).call
      end

      context "when the last trick winner attempts to play a card" do
        let(:player) { players(:player1) }
        let(:card)   { cards(:king_of_diamonds) }

        before { PlayCard.new(round, player, card).call }

        it "plays the card" do
          expect(card.trick).to eq(round.tricks.last)
        end
      end

      context "when anyone but the last trick winner attempts to play a card" do
        let(:player)    { players(:player2) }
        let(:card)      { cards(:jack_of_hearts)}
        let(:play_card) { PlayCard.new(round, player, card) }

        before          { play_card.call }

        it "doesn't play the card" do
          expect(card.trick).to be_nil
        end

        # TODO validate error message
        it "sets the error to 'not your turn'" do
          expect(play_card.errors).to include("it's not your turn to play")
        end
      end
    end
  end
end
