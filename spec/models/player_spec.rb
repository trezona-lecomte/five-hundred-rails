require "rails_helper"

RSpec.describe Player, type: :model do
  fixtures :all

  let(:round)  { rounds(:playing_round) }
  let(:player) { players(:player1) }

  it { should validate_presence_of :game }
  it { should validate_presence_of :user }

  it { should validate_numericality_of(:order_in_game).is_greater_than_or_equal_to(0) }

  it { should validate_uniqueness_of(:user).scoped_to(:game_id) }

  context "when destroyed" do
    it "destroys all dependent cards" do
      expect { player.destroy }.to change(Card, :count).by(-20)
    end

    it "destroys all dependent bids" do
      expect { player.destroy }.to change(Bid, :count).by(-3)
    end
  end
end
