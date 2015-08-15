require 'rails_helper'

RSpec.describe BidsController, type: :controller do
  fixtures :all

  let(:user)             { users(:user1) }
  let(:player)           { players(:bidder1) }
  let(:round)            { rounds(:bidding_round) }
  let(:valid_bid_params) { { number_of_tricks: "0", suit: "hearts" } }

  before do
    ApplicationController.any_instance.stub(:authenticate_user_from_token!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    subject { response }

    context "when the bid is valid" do
      before { post :create, round_id: round.id, number_of_tricks: "6", suit: "hearts" }

      it { is_expected.to have_http_status(201) }
    end

    context "when the bid is invalid" do
      before { post :create, round_id: round.id, number_of_tricks: "6", suit: "farts" }

      it { is_expected.to have_http_status(422) }
    end
  end
end
