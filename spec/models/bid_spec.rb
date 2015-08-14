require "rails_helper"

RSpec.describe Bid, type: :model do
  fixtures :all

  let(:round)  { rounds(:bidding_round) }
  let(:player) { players(:bidder1) }

  it { should validate_presence_of :round }
  it { should validate_presence_of :player }
  it { should validate_presence_of :suit }
  it { should validate_presence_of :number_of_tricks }
end
