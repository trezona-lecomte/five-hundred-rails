require "rails_helper"

describe PlayerTurnValidator, type: :validator do
  fixtures :all

  let(:game)        { games(:playing_game) }
  let(:round)       { rounds(:playing_round) }
  let(:trick)       { round.current_trick }
  let(:player)      { players(:player2) }
  let(:card)        { cards(:jack_of_hearts) }

  subject(:service) { PlayCard.new(round: round, player: player, card: card) }

  NOT_YOUR_TURN_TO_PLAY_ERROR     = "it's not your turn to play"

  describe "#validate" do
    context "when it is the first trick" do
      context "when no cards have been played yet" do
        before { service.valid? }

        context "when the bid-winner attempts to play a card" do
          it { is_expected.to be_valid }

          it "doesn't set any errors" do
            expect(service.errors[:base]).to be_empty
          end
        end

        context "when a non-winning bidder attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:king_of_hearts) }

          it { is_expected.to be_invalid }

          it "has a 'not your turn' error" do
            expect(service.errors[:base]).to include(NOT_YOUR_TURN_TO_PLAY_ERROR)
          end
        end
      end

      context "when cards have been played" do
        before do
          PlayCard.new(round: round, player: players(:player2), card: cards(:nine_of_clubs)).call
          PlayCard.new(round: round, player: players(:player3), card: cards(:seven_of_clubs)).call
          PlayCard.new(round: round, player: players(:player4), card: cards(:six_of_clubs)).call
        end

        context "when the correct player attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:queen_of_clubs) }

          it { is_expected.to be_valid }
        end

        3.times do |n|
          context "when an incorrect player tries to bid" do
            let(:player) { players("player#{n + 2}") }
            let(:card)   { player.cards.unplayed.sample }

            before { service.valid? }

            it { is_expected.to be_invalid }

            it "has the correct 'not your turn' error" do
              expect(service.errors[:base]).to include(NOT_YOUR_TURN_TO_PLAY_ERROR)
            end
          end
        end
      end
    end

    context "when it isn't the first trick" do
      before do
        PlayCard.new(round: round, player: players(:player2), card: cards(:ten_of_hearts)).call
        PlayCard.new(round: round, player: players(:player3), card: cards(:nine_of_hearts)).call
        PlayCard.new(round: round, player: players(:player4), card: cards(:six_of_hearts)).call
        PlayCard.new(round: round, player: players(:player1), card: cards(:king_of_hearts)).call
      end

      context "when no cards have been played into this trick" do
        context "when the last trick winner attempts to play a card" do
          let(:player) { players(:player1) }
          let(:card)   { cards(:king_of_diamonds) }

          it ""  do
            is_expected.to be_valid
          end
        end

        3.times do |n|
          context "when an incorrect player tries to bid" do
            let(:player) { players("player#{n + 2}") }
            let(:card)   { player.cards.unplayed.sample }

            before { service.valid? }

            it { is_expected.to be_invalid }

            it "has the correct 'not your turn' error" do
              expect(service.errors[:base]).to include(NOT_YOUR_TURN_TO_PLAY_ERROR)
            end
          end
        end
      end

      context "when cards have been played into this trick" do
        before do
          PlayCard.new(round: round, player: players(:player1), card: cards(:ace_of_diamonds)).call
        end

        context "when the correct player attempts to play a card" do
          let(:player)    { players(:player2) }
          let(:card)      { cards(:ten_of_diamonds) }

          it { is_expected.to be_valid }
        end

        3.times do |n|
          context "when an incorrect player tries to bid" do
            let(:player) { n.zero? ? players(:player1) : players("player#{n + 2}") }
            let(:card)   { player.cards.unplayed.sample }

            before { service.valid? }

            it { is_expected.to be_invalid }

            it "has the correct 'not your turn' error" do
              expect(service.errors[:base]).to include(NOT_YOUR_TURN_TO_PLAY_ERROR)
            end
          end
        end
      end
    end
  end
end
