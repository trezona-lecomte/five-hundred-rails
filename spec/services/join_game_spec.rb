require "rails_helper"

describe JoinGame, type: :service do
  fixtures :users, :games

  let(:game)    { Game.create! }
  let(:user)    { users(:user1) }
  let(:service) { JoinGame.new(game: game, user: user) }

  describe "#call" do
    context "when the game can be joined" do
      let!(:call_result) { service.call }
      let!(:player)      { service.player }

      it "returns true" do
        expect(call_result).to be_truthy
      end

      it "creates a player" do
        expect { JoinGame.new(game: game, user: users(:user2)).call }.to change(Player, :count).by(1)
      end

      it "associates the player with the correct user" do
        expect(player.user).to eq(user)
      end

      it "associates the player with the correct game" do
        expect(player.game).to eq(game)
      end
    end

    context "when the game can't be joined" do
      let!(:call_result) { service.call }
      let(:game)         { games(:playing_game) }

      it "returns false" do
        expect(call_result).to be false
      end

      it "doesn't creates a player" do
        expect { JoinGame.new(game: game, user: users(:user2)).call }.to_not change(Player, :count)
      end
    end
  end
end
