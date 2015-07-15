require 'rails_helper'

RSpec.describe JoinTeam, type: :service do
  fixtures :games
  fixtures :teams
  fixtures :users
  fixtures :players

  describe "#call" do
    let(:user1) { users(:user1) }
    let(:user2) { users(:user2) }
    let(:user)  { user1 }
    let(:game)  { games(:bidding_game) }
    let(:team1) { teams(:fresh_team_1) }
    let(:team2) { teams(:fresh_team_2) }
    let(:team)  { team1 }

    let(:team_joiner)   { JoinTeam.new(user) }
    subject(:join_team) { team_joiner.call(team) }

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
            expect(game.players.last.table_position).to eq(11)
          end
        end

        context "joins team 2" do
          let(:team) { team2 }

          before { join_team }

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
            expect(game.players.last.table_position).to eq(21)
          end
        end
      end

      context "when a second player joins a team" do
        before do
          JoinTeam.new(user1).call(team)
          JoinTeam.new(user2).call(team)
        end

        it "allocates a player number of 12" do
          expect(game.players.last.table_position).to eq(12)
        end
      end
    end

    context "when unsuccessful" do
      # TODO This belongs in the model spec:
      context "when a user tries to join the same team twice" do
        before { game.players.create!(user: user, team: team1, table_position: 21) }

        it "raises an error" do
          expect{ join_team }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "when more than #{Team::MAX_PLAYERS} players try to join a team" do
        let(:team) { teams(:full_team_1) }

        before { team_joiner.call(team) }

        it "adds an error to the team" do
          expect(team_joiner.error).to eq("No more than #{Team::MAX_PLAYERS} players can join this team.")
        end

        it "doesn't create any more than #{Team::MAX_PLAYERS} players on the team" do
          expect(team.players.count).to eq(Team::MAX_PLAYERS)
        end
      end

      context "when a user tries to join multiple teams on the same game" do
        before { team_joiner.call(team1) }

        it "raises an error" do
          expect{ team_joiner.call(team2) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end