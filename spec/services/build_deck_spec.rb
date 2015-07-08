require 'rails_helper'

RSpec.describe BuildDeck, type: :service do
  let(:deck_builder) { BuildDeck.new }

  describe "#call" do
    context "when a collection of cards is returned" do
      subject(:cards)          { deck_builder.call }
      let(:is_excluded_number) { proc { |card| [1, 2, 3, 16].include?(card.number) } }
      let(:is_black_four)      { proc { |card| card.number == 4 && %w(clubs spades).include?(card.suit) } }

      it "has of 43 cards" do
        expect(cards.count).to eq(43)
      end

      it "has a single joker" do
        expect(cards.select { |card| card.suit == "black_joker" }).to be_one
      end

      it "doesn't have excluded numbers" do
        expect(cards.select(&is_excluded_number)).to be_empty
      end

      it "doesn't have black 4s" do
        expect(cards.select(&is_black_four)).to be_empty
      end
    end
  end
end
