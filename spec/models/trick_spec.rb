require 'rails_helper'

RSpec.describe Trick, type: :model do
  let(:card)  { Card.create!(suit: Suits::HEARTS) }

  describe "adding cards" do
    subject(:trick) { Trick.create! }

    context "when up to 4 cards are played" do
      before { trick.cards = [card] * 4 }

      it { is_expected.to be_valid }
    end

    context "when more than 4 cards are played" do
      before { trick.cards = [card] * 5 }

      it { is_expected.to be_invalid }
    end
  end
end
