require "rails_helper"

RSpec.describe StartRound, type: :service do
  fixtures :all

  let(:game)        { games(:playing_game) }
  let(:start_round) { StartRound.new(game) }

  describe "#call" do
    context "when the game has no unfinished rounds" do
      before { allow(start_round).to receive(:all_existing_rounds_finished?).and_return(true) }

      it "creates a round" do
        expect { start_round.call }.to change { game.rounds.count }.by(1)
      end

      it "creates 10 tricks" do
        expect { start_round.call }.to change(Trick, :count).by(10)
      end

      it "returns true" do
        expect(start_round.call).to be true
      end
    end

    context "when the game has an unfinished round" do
      it "doesn't create a round" do
        expect { start_round.call }.to_not change(Round, :count)
      end

      it "doesn't create any tricks" do
        expect { start_round.call }.to_not change(Trick, :count)
      end

      it "returns false" do
        expect(start_round.call).to be_falsey
      end
    end
  end
end
