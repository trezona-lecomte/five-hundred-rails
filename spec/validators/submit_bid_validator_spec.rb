require "rails_helper"

describe SubmitBidValidator, type: :validator do
  fixtures :all

  let(:suit)             { Suits::NO_SUIT }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { Bid::PASS_TRICKS }
  let(:service_args)     { { round: round, player: player, number_of_tricks: number_of_tricks, suit: suit } }
  let(:service)          { SubmitBid.new(**service_args) }

  subject(:validator)    { SubmitBidValidator.new(service) }

  BIDDING_IS_FINISHED_ERROR = "bidding for this round has finished"

  describe "#bidding_is_open" do
    context "when the round is not in the bidding stage" do
      let(:round) { rounds(:playing_round) }

      before do
        binding.pry
        validator.valid?
      end

      it { is_expected.to be_invalid }

      it "has the correct 'round has finished' error" do
        expect(validator.errors[:base]).to include(BIDDING_IS_FINISHED_ERROR)
      end
    end
  end
end
