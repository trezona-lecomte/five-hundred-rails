require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:game)    { Game.create! }
  let(:team1)   { game.teams.create! }
  let(:team2)   { game.teams.create! }
  let(:player1) { Player.create!(name: Faker::Name.name) }
  let(:player2) { Player.create!(name: Faker::Name.name) }
  let(:player3) { Player.create!(name: Faker::Name.name) }

  describe "adding players" do
    it "allows 2 players to join" do
      team1.players << player1 << player2

      expect(team1).to be_valid
    end

    it "doesn't allow 3 players to join" do
      team1.players << player1 << player2 << player3

      expect(team1).to_not be_valid
    end

    it "doesn't allow a player to join the same team twice" do
      team1.players << player1
      expect{ team1.players << player1 }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "doesn't allow a player to join the same game twice" do
      team1.players << player1
      expect{ team2.players << player1 }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
