require "rails_helper"

RSpec.describe GamesController, type: :controller do
  fixtures :all

  let(:user)  { users(:user1) }
  let(:games) { Game.all }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user_from_token!).and_return true
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET index" do
    subject          { response }
    before           { get :index }

    it { is_expected.to have_http_status(200) }
  end

  # describe "POST #create" do
  #   subject { response }

  #   context "when the bid is valid" do
  #     before { post :create, round_id: round.id, number_of_tricks: "6", suit: "hearts" }

  #     it { is_expected.to have_http_status(201) }
  #   end

  #   context "when the bid is invalid" do
  #     before { post :create, round_id: round.id, number_of_tricks: "6", suit: "farts" }

  #     it { is_expected.to have_http_status(422) }
  #   end
  # end


end
