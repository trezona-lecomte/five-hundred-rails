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

  describe "GET show" do
    subject          { response }
    before           { get :show, id: games.first.id }

    it { is_expected.to have_http_status(200) }
  end

  describe "POST crete" do
    subject          { response }
    before           { post :create }

    it { is_expected.to have_http_status(201) }

    it "creates a game" do
      expect { post :create }.to change(Game, :count).by(1)
    end
  end
end
