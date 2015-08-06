require "rails_helper"

RSpec.describe "Games", :type => :request do
  before { 3.times { Game.create! } }

  describe "GET /games" do
    before { get "/games", format: :json }

    it "returns with 200 OK" do
      expect(response).to have_http_status(200)
    end


    it "returns a list of all the games" do
      expect(response.body).to include("games")
      expect(response.body).to include("1")
      expect(response.body).to include("2")
      expect(response.body).to include("3")
    end
  end

  describe "GET /games/:id" do
    before { get "/games/1", format: :json }

    it "returnw with 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the requested game" do
      expect(response.body).to include("1")
    end
  end

  describe "POST /games" do
    before { post "/games", game: {} }

    it "responds with 201 Created" do
      expect(response).to have_http_status(201)
    end

    it "creates a game" do
      expect { post "/games", game: {} }.to change(Game, :count).by(1)
    end
  end

  # TODO will need to rely on fixtures once bidding is implemented..
  # describe "PUT /games/:id" do
  #   before do
  #     game = Game.create!
  #     4.times { JoinGame.new(game, Faker::Internet.user_name).call }
  #     start_round = StartRound.new(game)
  #     start_round.call
  #     deck = BuildDeck.new.call
  #     DealCards.new(game, start_round.round, deck).call

  #     put "/games/1", { round_id: game.rounds.first.id, player_id: game.players, card_id: 1 }
  #   end

  #   it "updates the game with the card specified" do
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
