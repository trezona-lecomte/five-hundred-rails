require "rails_helper"

describe PlayCard, type: :service do
  fixtures :all

  let(:game)         { games(:playing_game) }
  let(:round)        { rounds(:playing_round) }
  let(:player)       { players(:player2) }
  let(:card)         { cards(:jack_of_hearts) }
  let(:service_args) { { round: round, player: player, card: card } }

  subject(:service) { PlayCard.new(**service_args) }

  CARD_NOT_IN_HAND_ERROR          = "you don't have this card in your hand"
  ROUND_CANNOT_BE_PLAYED_ON_ERROR = "this round isn't in the playing stage"

  describe "#call" do
    before { allow(service).to receive(:valid?).and_return(validity) }

    context "when the play is valid" do
      let(:validity) { true }

      it "plays the card" do
        expect { service.call }.to change { card.trick }.from(nil).to(round.current_trick)
      end
    end

    context "when the play is not valid" do
      let(:validity) { false }

      it "doesn't play the card" do
        expect { service.call }.to_not change { card.trick }
      end
    end
  end

  describe "#validations" do
    context "when the player doesn't own the card" do
      before do
        allow(card).to receive(:player).and_return(nil)
        service.valid?
      end

      it { is_expected.to be_invalid }

      it "has a 'don't have this card' error" do
        expect(service.errors[:base]).to include(CARD_NOT_IN_HAND_ERROR)
      end
    end

    context "when the player has already played the card" do
      before do
        allow(card).to receive(:played?).and_return(true)
        service.valid?
      end

      it { is_expected.to be_invalid }

      it "has a 'don't have this card' error" do
        expect(service.errors[:base]).to include(CARD_NOT_IN_HAND_ERROR)
      end
    end

    context "when the round isn't in the playing stage" do
      before do
        allow(round).to receive(:in_playing_stage?).and_return(false)
        service.valid?
      end

      it { is_expected.to be_invalid }

      it "has a 'round can't be played on' error" do
        expect(service.errors[:base]).to include(ROUND_CANNOT_BE_PLAYED_ON_ERROR)
      end
    end
  end
end
