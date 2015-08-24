require "rails_helper"

RSpec.describe Bid, type: :model do
  fixtures :all

  let(:round)  { rounds(:bidding_round) }
  let(:player) { players(:bidder1) }

  it { should validate_presence_of :round }
  it { should validate_presence_of :player }
  it { should validate_presence_of :suit }
  it { should validate_presence_of :number_of_tricks }

  it { should validate_numericality_of(:order_in_round).is_greater_than_or_equal_to(0) }
  it { should validate_inclusion_of(:number_of_tricks).in_array(Bid::ALLOWED_TRICKS) }
end
