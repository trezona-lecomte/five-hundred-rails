require "rails_helper"

RSpec.describe StartRound, type: :service do
  let(:game)        { Game.create! }
  let(:start_round) { StartRound.new(game) }

  describe "#call" do
    context "when the game has no unfinished rounds" do
      it "creates a new round on the game" do
        expect { start_round.call }.to change { game.rounds.count }.by(1)
      end

      it "initializes the round with 10 tricks" do
        expect { start_round.call }.to change(Trick, :count).by(10)
      end
    end

    context "when the game has an unfinished round" do
      let(:game)  { Game.create! }
      before { game.rounds.create! }

      subject { start_round.call }

      it { is_expected.to be false }

      it "doesn't create a round" do
        expect { start_round.call }.to_not change(Round, :count)
      end

      it "doesn't create any tricks" do
        expect { start_round.call }.to_not change(Trick, :count)
      end
    end
  end
end
