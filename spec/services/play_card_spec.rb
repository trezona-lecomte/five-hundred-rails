require 'rails_helper'

RSpec.describe PlayCard, type: :service do
  fixtures :all

  let(:game)   { games(:playing_game) }
  let(:round)  { rounds(:playing_round) }
  let(:trick)  { tricks(:first_trick) }
  # let(:kieran) { players(:kieran) }
  # let(:mitch)  { players(:mitch) }
  # let(:pragya) { players(:pragya) }
  # let(:mikee)  { players(:mikee) }
  let(:player) { players(:kieran) }
  let(:card)   { playing_cards(:kierans_joker) }

  describe "#call" do
    let(:card_player)   { PlayCard.new(round: round, player: player) }
    subject(:play_card) { card_player.call(playing_card: card, trick: trick) }

    context "when the card can be played" do
      it "adds the card to the trick" do
        expect{ play_card }.to change{ trick.playing_cards.count }.by(1)
      end
    end

    context "when the card cannot be played" do
      context "when played out of turn" do
        let(:player) { players(:mitch) }

        it "doesn't add the card to the trick" do
          expect{ play_card }.to_not change{ trick.playing_cards.count }
        end
        # it "raises error" do
          # expect{ play_card }.to raise_error(ActiveRecord::RecordInvalid)
        # end
      end

      context "when the trick has finished" do

      end

      context "when the card doesn't follow suit" do

      end

      context "when the game isn't in the playing stage" do
        let(:round)  { rounds(:bidding_round) }

        before { play_card }

        it "stores a 'cards can't be played' error" do
          expect(card_player.error).to eq("Cards can't be played at this stage of the game.")
        end
      end
    end
  end
end
