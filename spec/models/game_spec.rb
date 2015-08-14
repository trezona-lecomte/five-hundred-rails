require "rails_helper"

RSpec.describe Game, type: :model do
  fixtures :all

  let(:game)   { games(:bidding_game) }
  let(:player) { players(:bidder1) }

  context "when destroyed" do
    it "destroys all dependent players" do
      expect { game.destroy }.to change(Player, :count).by(-4)
    end

    it "destroys all dependent rounds" do
      expect { game.destroy }.to change(Round, :count).by(-1)
    end
  end
end
