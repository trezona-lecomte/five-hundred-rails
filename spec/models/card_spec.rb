require "rails_helper"

RSpec.describe Card, type: :model do
  let(:round) { Game.create!.rounds.create! }

  subject { Card.create!(rank: Card.ranks.keys.first, suit: Card.suits.keys.first, round: round) }

  it { should validate_presence_of :round }
  it { should validate_presence_of :suit }
  it { should validate_presence_of :rank }
  it { should_not validate_presence_of :player }
  it { should_not validate_presence_of :trick }
  it { should_not validate_presence_of :number_in_trick }

  it { should validate_uniqueness_of(:round).scoped_to(:rank, :suit) }
  it { should validate_uniqueness_of(:number_in_trick).scoped_to(:trick_id).allow_nil }
end
