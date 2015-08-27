require "rails_helper"

describe Bid, type: :model do
  fixtures :all

  let(:round)  { rounds(:bidding_round) }
  let(:player) { players(:bidder1) }

  # TODO replace should with is_expected.to
  it { is_expected.to validate_presence_of :round }
  it { is_expected.to validate_presence_of :player }
  it { is_expected.to validate_presence_of :number_of_tricks }

  it { is_expected.to validate_inclusion_of(:number_of_tricks).in_array(Bid::ALLOWED_TRICKS) }
end
