require "rails_helper"

RSpec.describe NextPlayer, type: :service do
  fixtures :all
  let(:find_next_player) { NextPlayer.new(round) }

  describe "#call" do
    before { find_next_player.call }

    context "when bidding has finished" do
      let(:round) { rounds(:playing_round) }

      it "returns the player who won the bidding" do
        expect(find_next_player.next_player).to eq(players(:player2))
      end
    end
  end
end
