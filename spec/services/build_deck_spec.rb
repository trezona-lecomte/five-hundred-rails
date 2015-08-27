require "rails_helper"

describe BuildDeck, type: :service do
  describe "#call" do
    let(:build_deck) { BuildDeck.new }

    context "when the deck is successfully built" do
      it "returns a standard-size deck of cards" do
        expect(build_deck.call.size).to eq(43)
      end
    end
  end
end
