require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game)    { Game.create! }
  let(:players) { [Player.create!(name: Faker::Name.name),
                   Player.create!(name: Faker::Name.name),
                   Player.create!(name: Faker::Name.name),
                   Player.create!(name: Faker::Name.name),
                   Player.create!(name: Faker::Name.name)] }

  describe "adding players" do
    (0..3).each do |n|
      it "allows #{n + 1} players to join" do
        game.players = players.pop(n)
        expect(game).to be_valid
      end
    end

    it "doesn't allow 5 players to join" do
      game.players = players.pop(5)
      expect(game).to_not be_valid
    end
  end
end
