require 'rails_helper'

RSpec.describe Trick, type: :model do
  fixtures :playing_cards
  let(:playing_card)  { playing_cards(:kierans_ace_of_spades) }

  describe "adding cards" do
    subject(:trick) { Trick.create! }

    context "when up to 4 cards are played" do
      before do
        trick.playing_cards << playing_cards(:kierans_ace_of_spades)
        trick.playing_cards << playing_cards(:mitches_8_of_spades)
        trick.playing_cards << playing_cards(:pragyas_jack_of_spades)
        trick.playing_cards << playing_cards(:mikees_6_of_spades)
      end

      it { is_expected.to be_valid }
    end

    context "when more than 4 cards are played" do
      before do
        trick.playing_cards << playing_cards(:kierans_ace_of_spades)
        trick.playing_cards << playing_cards(:mitches_8_of_spades)
        trick.playing_cards << playing_cards(:pragyas_jack_of_spades)
        trick.playing_cards << playing_cards(:mikees_6_of_spades)
        trick.playing_cards << playing_cards(:kierans_joker)
      end

      it { is_expected.to be_invalid }
    end
  end
end
