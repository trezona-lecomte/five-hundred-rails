require "rails_helper"

describe Game, type: :model do
  fixtures :all

  let(:game)   { games(:bidding_game) }
  let(:player) { players(:bidder1) }

  context "when destroyed" do
    it "destroys all dependent players" do
      expect { game.destroy }.to change(Player, :count).by(-4)
    end

    it "destroys all dependent rounds" do
      expect { game.destroy }.to change(Round, :count).by(-1)
    end
  end

  describe "active_round" do
    subject { game.active_round }

    context "when the game isn't finished" do
      let(:active_round) { game.rounds.last }

      it { is_expected.to eq(active_round) }
    end

    context "when the game is finished" do
      before { allow(game).to receive(:finished?).and_return(true) }

      it { is_expected.to be nil }
    end
  end

  describe "odd_players_score" do
    subject { game.odd_players_score }

    context "when no rounds have been scored" do
      it { is_expected.to be 0 }
    end

    context "when the total of the odd teams score across all rounds is 290" do
      before do
        game.rounds.create!(order_in_game: 1,
                            odd_players_score: -50,
                            even_players_score: 10)
        game.rounds.create!(order_in_game: 2,
                            odd_players_score: 100,
                            even_players_score: -40)
        game.rounds.create!(order_in_game: 3,
                            odd_players_score: 240,
                            even_players_score: 50)
      end

      it { is_expected.to be 290 }
    end
  end

  describe "even_players_score" do
    subject { game.even_players_score }

    context "when no rounds have been scored" do
      it { is_expected.to be 0 }
    end

    context "when the total of the even teams score across all rounds is 20" do
      before do
        game.rounds.create!(order_in_game: 1,
                            odd_players_score: 50,
                            even_players_score: 10)
        game.rounds.create!(order_in_game: 2,
                            odd_players_score: 100,
                            even_players_score: -40)
        game.rounds.create!(order_in_game: 3,
                            odd_players_score: 240,
                            even_players_score: 50)
      end

      it { is_expected.to be 20 }
    end
  end
end
