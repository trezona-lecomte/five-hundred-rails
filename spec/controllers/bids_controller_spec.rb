require 'rails_helper'

describe BidsController, type: :controller do
  fixtures :all

  let(:user)             { users(:user1) }
  let(:player)           { players(:bidder1) }
  let(:round)            { rounds(:bidding_round) }
  let(:valid_bid_params) { { round_id: round, pass: true } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user_from_token!).and_return true
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST create" do
    context "when the bid is valid" do
      it "responds with http status 201" do
        post :create, valid_bid_params

        expect(response).to have_http_status(201)
      end

      it "creates a bid" do
        expect { post :create, valid_bid_params }.to change(Bid, :count).by(1)
      end
    end

    context "when the bid is invalid" do
      it "responds with http status 422" do
        post :create, { round_id: round, pass: false, number_of_tricks: Bid::MAX_TRICKS + 1, suit: "hearts" }

        expect(response).to have_http_status(422)
      end

      it "doesn't create a bid" do
        expect { post :create, { round_id: round, pass: false } }.to_not change(Bid, :count)
      end
    end
  end
end
