require "rails_helper"

RSpec.describe FindAvailableBidParams, type: :service do
  fixtures :all

  describe "#call" do
    let(:round)       { rounds(:bidding_round) }
    let(:service)     { FindAvailableBidParams.new(round) }
    let(:call_result) { service.call }

    context "when the round is in the bidding stage" do
      before { service.call }

      let(:bid_params)        { service.available_bid_params }

      context "when no bids have been made" do
        it "returns true" do
          expect(call_result).to be true
        end

        it "generates a full list of all possible bids" do
          expect(bid_params).to eq(all_possible_bid_params)
        end
      end

      context "when bids have been made" do
        let(:highest_bid)   { Bid.create!(round: round,
                                          suit: Suits::ALL_SUITS.sample,
                                          number_of_tricks: (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.sample,
                                          player: players(:bidder1),
                                          order_in_round: round.bids.count + 1) }
        let(:excluded_bid_params) { excluded_bid_params_for(highest_bid) }

        before do
          allow(service).to receive(:any_bids?).and_return(true)
          allow(round).to receive(:highest_bid).and_return(highest_bid)
          service.call
        end

        it "returns true" do
          expect(call_result).to be true
        end

        it "generates a list of all bids higher than the last submitted bid & and a pass" do
          expect(service.available_bid_params).to eq(all_possible_bid_params - excluded_bid_params)
        end
      end
    end

    context "when the round is in the playing stage" do
      let(:round) { rounds(:playing_round) }

      it "returns false" do
        expect(call_result).to be false
      end
    end

    context "when the round is finished" do
      let(:round) { rounds(:finished_round) }

      it "returns false" do
        expect(call_result).to be false
      end
    end

    def all_possible_bid_params
      [Bid.params_for_pass_bid] +
      (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.product(Bid.suits.keys).map do |tricks, suit|
        { number_of_tricks: tricks, suit: suit }
      end
    end

    def excluded_bid_params_for(highest_bid)
      bid_params_lower_than(highest_bid) << { number_of_tricks: highest_bid.number_of_tricks, suit: highest_bid.suit }
    end

    def bid_params_lower_than(highest_bid)
      highest_tricks = highest_bid.number_of_tricks
      highest_suit = highest_bid.suit

      all_possible_bid_params.select do |params|
        params[:number_of_tricks] != Bid::PASS_TRICKS &&
          ((params[:number_of_tricks] < highest_tricks) ||
            (params[:number_of_tricks] == highest_tricks && Bid.suits[params[:suit]] < Bid.suits[highest_suit]))
      end
    end
  end

end
