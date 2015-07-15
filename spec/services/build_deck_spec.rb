require 'rails_helper'

RSpec.describe BuildDeck, type: :service do
  fixtures :cards

  describe "#call" do
    context "when a standard deck of cards is built" do
      let(:deck_builder)       { BuildDeck.new("standard") }
      let(:is_excluded_number) { proc { |card| [1, 2, 3, 16].include?(card.number) } }
      let(:is_black_four)      { proc { |card| card.number == 4 && %w(clubs spades).include?(card.suit) } }

      before { deck_builder.call }

      it "has of 43 cards" do
        expect(deck_builder.cards.count).to eq(43)
      end

      it "has a single joker" do
        expect(deck_builder.cards.select { |card| card.number == 15 } ).to be_one
        expect(deck_builder.cards.select { |card| card.suit == Suits::NO_TRUMPS } ).to be_one
      end

      it "doesn't have excluded numbers" do
        expect(deck_builder.cards.select(&is_excluded_number)).to be_empty
      end

      it "doesn't have black 4s" do
        expect(deck_builder.cards.select(&is_black_four)).to be_empty
      end

      it "has one of each card from red 4s to Aces" do
        (5..14).each do |number|
          %w(hearts diamonds clubs spades).each do |suit|
            expect(deck_builder.cards.select { |card| card.number == number && card.suit == suit }).to be_one
          end
        end
      end

      it "has the two red 4s" do
        expect(deck_builder.cards.select { |card| card.number == 4 && card.suit == "hearts" }).to be_one
        expect(deck_builder.cards.select { |card| card.number == 4 && card.suit == "diamonds" }).to be_one
      end
    end
  end
end
