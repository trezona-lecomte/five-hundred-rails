require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game)  { Game.create! }

  describe "adding teams" do
    it "allows 2 teams to join" do
      2.times { game.teams.create! }

      expect(game).to be_valid
    end

    it "doesn't allow 3 teams to join" do
      3.times { game.teams.create! }

      expect(game).to_not be_valid
    end
  end
end
