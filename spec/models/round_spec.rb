require "rails_helper"

RSpec.describe Round, type: :model do
  fixtures :all

  let(:round)  { rounds(:playing_round) }

  it { should validate_presence_of :game }

  context "when destroyed" do
    it "destroys all dependent cards" do
      expect { round.destroy }.to change(Card, :count).by(-43)
    end

    it "destroys all dependent bids" do
      expect { round.destroy }.to change(Bid, :count).by(-9)
    end

    it "destroys all dependent tricks" do
      expect { round.destroy }.to change(Trick, :count).by(-10)
    end
  end
end
