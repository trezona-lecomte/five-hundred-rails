require 'rails_helper'

RSpec.describe JoinTeam, type: :service do
  let(:user)  { User.create!(username: Faker::Internet.user_name) }
  let(:game)  { CreateGame.new.call }
  let(:team1) { game.teams.first }
  let(:team2) { game.teams.last }

  describe "#call" do
    subject(:join_team) { JoinTeam.new.call(user, team1) }

    context "when successful" do
      it "creates a new player" do
        expect{ join_team }.to change(Player, :count).by(1)
      end

      context "when the first player" do
        context "joins team 1" do
          before { join_team }

          it "assigns the player to team 1" do
            expect(game.players.last.team.number).to eq(1)
          end

          it "associates the player with the correct game" do
            expect(game.players.last).to eq(Player.last)
          end

          it "associates player with the correct user" do
            expect(game.players.last.user).to eq(user)
          end

          it "allocates a player number of 11" do
            expect(game.players.last.number).to eq(11)
          end
        end

        context "joins team 2" do
          before { JoinTeam.new.call(user, team2) }

          it "assigns the player to team 2" do
            expect(game.players.last.team.number).to eq(2)
          end

          it "associates the player with the correct game" do
            expect(game.players.last).to eq(Player.last)
          end

          it "associated player with the correct user" do
            expect(game.players.last.user).to eq(user)
          end

          it "allocates a player number of 21" do
            expect(game.players.last.number).to eq(21)
          end
        end
      end

      context "when a second player joins a team" do
        before do
          JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), team1)
          JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), team1)
        end

        it "allocates a player number of 12" do
          expect(game.players.last.number).to eq(12)
        end
      end
    end

    context "when unsuccessful" do
      context "when a user tries to join the same team twice" do
        before { game.players.create!(user: user, team: team1, number: 21) }

        it "raises an error" do
          expect{ join_team }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "when more than #{Team::MAX_PLAYERS} players try to join a team" do
        before do
          (Team::MAX_PLAYERS + 1).times do
            JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), team1)
          end
        end

        it "adds an error to the team" do
          expect(team1).to have(1).errors
        end

        it "doesn't create any more than #{Team::MAX_PLAYERS} players on the team" do
          expect(team1.players.count).to eq(Team::MAX_PLAYERS)
        end
      end

      context "when a user tries to join multiple teams on the same game" do
        before do
          JoinTeam.new.call(user, team1)
        end

        it "raises an error" do
          expect{ JoinTeam.new.call(user, team2) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end