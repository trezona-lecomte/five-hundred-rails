require "rails_helper"

RSpec.describe NextBidderValidator, type: :validator do
  fixtures :all

  let(:suit)             { Suits::NO_SUIT }
  let(:round)            { rounds(:bidding_round) }
  let(:player)           { players(:bidder1) }
  let(:number_of_tricks) { Bid::PASS_TRICKS }
  let(:service_args)     { [round, player, number_of_tricks, suit]}
  let(:service)          { SubmitBid.new(*service_args) }
  let(:validator)        { NextBidderValidator}

  describe "#validate" do
    before { }
    context "when it is the first bid of the round" do
      context "when the correct player tries to bid" do
        it "doesn't set any errors on submit_bid" do
          expect(submit_bid.errors[:base]).to be_empty
        end
      end

      context "when an incorrect player tries to bid" do

      end
    end
  end
end
