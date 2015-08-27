require 'rails_helper'

describe BidsController, type: :controller do
  fixtures :all

  let(:user)             { users(:user1) }
  let(:player)           { players(:bidder1) }
  let(:round)            { rounds(:bidding_round) }
  let(:valid_bid_params) { { round_id: round, number_of_tricks: Bid::PASS_TRICKS, suit: Suits::HEARTS } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user_from_token!).and_return true
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST crete" do
    subject          { response }
    before           { post :create, valid_bid_params }

    it { is_expected.to have_http_status(201) }

    # it "creates a bid" do
    #   expect { post :create, valid_bid_params }.to change(Bid, :count).by(1)
    # end
  end
end
