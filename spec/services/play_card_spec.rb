require 'rails_helper'

RSpec.describe PlayCard, type: :service do
  fixtures :tricks
  fixtures :cards

  describe "#call" do
    subject(:play_card) { PlayCard.new.call(card: card, trick: trick) }
    let(:trick)         { tricks(:fresh_trick) }
    let(:card)          { cards(:ace_of_spades) }

    context "when the card can be played" do

      it "adds the card to the trick" do
        expect{ play_card }.to change{ trick.cards.count }.by(1)
      end
    end

    context "when the card cannot be played" do
      context "when played out of turn" do
        # it "raises error" do
          # expect{ play_card }.to raise_error(ActiveRecord::RecordInvalid)
        # end
      end

      context "when the trick has finished" do

      end

      context "when the card doesn't follow suit" do

      end
    end
  end
end
