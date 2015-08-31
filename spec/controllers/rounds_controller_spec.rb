require "rails_helper"

describe RoundsController, type: :controller do
  fixtures :all

  let(:user)         { users(:user2) }
  let(:round)        { rounds(:playing_round) }
  let(:card)         { cards(:jack_of_diamonds) }
  let(:valid_params) { { id: round, card_id: card } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user_from_token!).and_return true
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET show" do
    it "responds with http status 200" do
      get :show, { id: round }

      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH update" do
    context "when the update is valid" do
      it "responds with http status 200" do
        patch :update, valid_params

        expect(response).to have_http_status(200)
      end
    end

    context "when the update is invalid" do
      before { patch :update, valid_params }

      it "responds with http status 422" do
        patch :update, valid_params

        expect(response).to have_http_status(422)
      end
    end
  end
end
