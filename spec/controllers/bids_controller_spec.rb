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
    before { post :create, round_id: round.id, number_of_tricks: "0", suit: "hearts" }

    context "when the user is valid" do
      subject { response }

      it do
        is_expected.to have_http_status(201)
      end
    end
  end
end
