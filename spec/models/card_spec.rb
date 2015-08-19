# TODO think about testing interactions rather than testing state.
require "rails_helper"

RSpec.describe Card, type: :model do
  let(:round) { Game.create!.rounds.create! }
  let(:trick) { round.tricks.create!(number_in_round: 1) }

  subject { Card.create!(rank: Card.ranks.keys.first, suit: Card.suits.keys.first, round: round) }

  it { should validate_presence_of :round }
  it { should validate_presence_of :suit }
  it { should validate_presence_of :rank }
  it { should_not validate_presence_of :player }
  it { should_not validate_presence_of :trick }
  it { should_not validate_presence_of :number_in_trick }

  it { should validate_uniqueness_of(:round).scoped_to(:rank, :suit) }

  # TODO wrap with context:
  it "should require unique value for number_in_trick scoped to trick_id" do
    trick.cards.create!(number_in_trick: 1,
                        rank: 10,
                        suit: Card.suits[:hearts],
                        round: round)
    card = trick.cards.new(number_in_trick: 1,
                           rank: 11,
                           suit: Card.suits[:hearts],
                           round: round)

    expect(card).to_not be_valid

    expect(card.errors[:number_in_trick]).to include("has already been taken")
  end
end
