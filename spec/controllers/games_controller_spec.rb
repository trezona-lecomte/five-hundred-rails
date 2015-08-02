require "rails_helper"

RSpec.describe GamesController, type: :controller do
  let(:valid_session) { {} }
  let(:game) { Game.create! }
  render_views

  describe "GET #index" do
    it "assigns all games as @games" do
      game = Game.create!
      get :index, valid_session, format: :json
      expect(assigns(:games)).to eq([game])
    end
  end

  describe "GET #show" do
    it "assigns the requested game as @game" do
      game = Game.create!
      get :show, { id: game.to_param }, valid_session
      expect(assigns(:game)).to eq(game)
    end

    context "when the game can't be found" do
      it "responds with 404 Not Found" do
        get :show, { id: 0 }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before { post :create, valid_session }

      it "creates a new Game" do
        expect {
          post :create, valid_session
        }.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        expect(assigns(:game)).to be_a(Game)
        expect(assigns(:game)).to be_persisted
      end

      it "responds with 201 Created" do
        expect(response).to have_http_status(201)
      end
    end
  end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested game" do
  #       game = Game.create! valid_attributes
  #       put :update, {:id => game.to_param, :game => new_attributes}, valid_session
  #       game.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested game as @game" do
  #       game = Game.create! valid_attributes
  #       put :update, {:id => game.to_param, :game => valid_attributes}, valid_session
  #       expect(assigns(:game)).to eq(game)
  #     end

  #     it "redirects to the game" do
  #       game = Game.create! valid_attributes
  #       put :update, {:id => game.to_param, :game => valid_attributes}, valid_session
  #       expect(response).to redirect_to(game)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the game as @game" do
  #       game = Game.create! valid_attributes
  #       put :update, {:id => game.to_param, :game => invalid_attributes}, valid_session
  #       expect(assigns(:game)).to eq(game)
  #     end

  #     it "re-renders the 'edit' template" do
  #       game = Game.create! valid_attributes
  #       put :update, {:id => game.to_param, :game => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested game" do
  #     game = Game.create!
  #     expect {
  #       delete :destroy, {:id => game.to_param}, valid_session
  #     }.to change(Game, :count).by(-1)
  #   end

  #   it "returns a 204 no content http status code" do
  #     delete :destroy, {:id => game.to_param}, valid_session
  #     expect(response.status).to eq(204)
  #   end
  # end
end
