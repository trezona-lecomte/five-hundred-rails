require "rails_helper"

RSpec.describe PlayCard, type: :service do
  fixtures :all
  let(:game)      { games(:playing_game) }
  let(:round)     { rounds(:playing_round) }
  let(:trick)     { round.current_trick }
  let(:player)    { players(:player2) }
  let(:card)      { cards(:jack_of_hearts) }
  let(:play_card) { PlayCard.new(trick: trick, player: player, card: card) }

  TRICK_NOT_ACTIVE_ERROR          = "this trick is not active"
  NOT_YOUR_TURN_ERROR             = "it's not your turn to play"
  CARD_NOT_IN_HAND_ERROR          = "you don't have this card in your hand"
  ROUND_CANNOT_BE_PLAYED_ON_ERROR = "cards can't be played on this round"

  describe "#call" do

    context "when the player doesn't have the card in their hand" do
      let(:call_result) { play_card.call }

      before do
        allow(card).to receive(:player).and_return(nil)
        play_card.call
      end

      it "returns false" do
        expect(call_result).to be false
      end

      it "sets a 'don't have this card' error" do
        expect(play_card.errors[:base]).to include(CARD_NOT_IN_HAND_ERROR)
      end
    end

    context "when the round isn't in the playing stage" do
      let(:call_result) { play_card.call }

      before do
        allow(round).to receive(:in_playing_stage?).and_return(false)
        play_card.call
      end

      it "returns false" do
        expect(call_result).to be false
      end

      it "sets a 'round can't be played on' error" do
        expect(play_card.errors[:base]).to include(ROUND_CANNOT_BE_PLAYED_ON_ERROR)
      end
    end

    context "when the trick isn't active" do
      let(:call_result) { play_card.call }

      before do
        allow(play_card).to receive(:trick_active?).and_return(false)
        play_card.call
      end

      it "returns false" do
        expect(call_result).to be false
      end

      it "sets a 'trick not active' error" do
        expect(play_card.errors[:base]).to include(TRICK_NOT_ACTIVE_ERROR)
      end
    end

    context "when it is the first trick" do
      context "when no cards have been played yet" do
        before { play_card.call }

        context "when the bid-winner attempts to play a card" do
          it "plays the card into the correct trick" do
            expect(card.trick).to eq(round.current_trick)
          end

          it "doesn't set any errors" do
            expect(play_card.errors[:base]).to be_empty
          end
        end

        context "when a non-winning bidder attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:king_of_hearts) }

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "sets a 'not your turn' error" do
            expect(play_card.errors[:base]).to include(NOT_YOUR_TURN_ERROR)
          end
        end
      end

      context "when cards have been played" do
        before do
          pc = PlayCard.new(trick: trick, player: players(:player2), card: cards(:nine_of_clubs))
          pc.call
          pc = PlayCard.new(trick: trick, player: players(:player3), card: cards(:seven_of_clubs))
          pc.call

          play_card.call

        end

        context "when the correct player attempts to play" do
          let(:player) { players(:player4) }
          let(:card)   { cards(:five_of_clubs) }

          it "plays the card into the correct trick" do
            expect(card.trick).to eq(round.current_trick)
          end

          it "doesn't set any errors" do
            expect(play_card.errors[:base]).to be_empty
          end
        end

        context "when an incorrect player attempts to play" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:queen_of_clubs) }

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "doesn't set any errors" do
            expect(play_card.errors[:base]).to include(NOT_YOUR_TURN_ERROR)
          end
        end
      end
    end

    context "when it isn't the first trick" do
      before do
        PlayCard.new(trick: trick, player: players(:player2), card: cards(:ten_of_hearts)).call
        PlayCard.new(trick: trick, player: players(:player3), card: cards(:nine_of_hearts)).call
        PlayCard.new(trick: trick, player: players(:player4), card: cards(:six_of_hearts)).call
        PlayCard.new(trick: trick, player: players(:player1), card: cards(:king_of_hearts)).call
      end

      context "when no cards have been played into this trick" do
        let(:play_card) { PlayCard.new(trick: round.current_trick, player: player, card: card) }

        context "when the last trick winner attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:king_of_diamonds) }

          before { play_card.call }

          it "plays the card into the correct trick" do
            expect(card.trick).to eq(round.current_trick)
          end

          it "doesn't set any errors" do
            expect(play_card.errors[:base]).to be_empty
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
            expect(play_card.errors[:base]).to include(NOT_YOUR_TURN_ERROR)
          end
        end
      end

      context "when cards have been played into this trick" do
        before do
          PlayCard.new(trick: round.current_trick, player: players(:player1), card: cards(:ace_of_diamonds)).call
        end

        context "when the correct player attempts to play a card" do
          let(:player)    { players(:player2) }
          let(:card)      { cards(:ten_of_diamonds) }
          let(:play_card) { PlayCard.new(trick: round.current_trick, player: player, card: card) }

          before { play_card.call }

          it "plays the card into the correct trick" do
            expect(card.trick).to eq(round.current_trick)
          end

          it "doesn't set any errors" do
            expect(play_card.errors[:base]).to be_empty
          end
        end

        context "when an incorrect player attempts to play a card" do
          let(:player)    { players(:player3) }
          let(:card)      { cards(:nine_of_diamonds) }
          let(:play_card) { PlayCard.new(trick: round.current_trick, player: player, card: card) }

          before { play_card.call }

          it "doesn't play the card" do
            expect(card.trick).to be_nil
          end

          it "sets the error to 'not your turn'" do
            expect(play_card.errors[:base]).to include(NOT_YOUR_TURN_ERROR)
          end
        end
      end
    end
  end
end
