require "rails_helper"

RSpec.describe StartRound, type: :service do
  let(:game)        { Game.create! }
  let(:start_round) { StartRound.new(game) }

  describe "#call" do
    context "when the round can be started" do
      it "creates a new round on the game" do
        expect { start_round.call }.to change { game.rounds.count }.by(1)
      end

      it "initializes the round with 10 tricks" do
        expect { start_round.call }.to change(Trick, :count).by(10)
      end
    end
  end
end
