require "rails_helper"

RSpec.describe PlayCard, type: :service do
  fixtures :all

  let(:game)         { games(:playing_game) }
  let(:round)        { rounds(:playing_round) }
  let(:trick)        { round.current_trick }
  let(:player)       { players(:player2) }
  let(:card)         { cards(:jack_of_hearts) }
  let(:service_args) { { trick: trick, player: player, card: card } }
  let(:service)      { PlayCard.new(**service_args) }

  describe "#call" do
    before { allow(service).to receive(:valid?).and_return(validity) }

    context "when the play is valid" do
      let(:validity) { true }

      it "plays the card" do
        expect { service.call }.to change { card.trick }.from(nil).to(trick)
      end
    end

    context "when the play is not valid" do
      let(:validity) { false }

      it "doesn't play the card" do
        expect { service.call }.to_not change { card.trick }
      end
    end
  end
end
