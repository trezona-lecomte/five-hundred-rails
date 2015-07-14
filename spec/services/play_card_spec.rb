require 'rails_helper'

RSpec.describe PlayCard, type: :service do
  fixtures :tricks
  fixtures :cards
  fixtures :games
  # let(:game)    { CreateGame.new.call }
  fixtures :rounds
  let(:round)   { game.rounds.first }
  let(:player1) { game.teams.first.players.first }
  let(:player2) { game.teams.last.players.first }
  let(:player3) { game.teams.first.players.last }
  let(:player4) { game.teams.last.players.last }
  let(:players) { [player1, player2, player3, player4] }
  let(:not_turn_error)       { "It's not your turn to bid." }
  let(:bid_too_low_error)    { "Your last bid was too low." }
  let(:bidding_over_error)   { "Bidding for this round has finished." }

  before do
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.first)
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.first)
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.last)
    JoinTeam.new.call(User.create!(username: Faker::Internet.user_name), game.teams.last)

    deck = BuildDeck.new.call
    DealRound.new.call(game, deck, [11, 21, 12, 22])
  end

  describe "#call" do
    let(:trick)         { tricks(:fresh_trick) }
    let(:card)          { cards(:ace_of_spades) }
    let(:card_player)   { PlayCard.new(round: round, player: player) }
    subject(:play_card) { card_player.call(card: card, trick: trick) }

    context "when the card can be played" do

      it "adds the card to the trick" do
        expect{ play_card }.to change{ trick.cards.count }.by(1)
      end
    end

    context "when the card cannot be played" do
      context "when played out of turn" do
        # it "raises error" do
          # expect{ play_card }.to raise_error(ActiveRecord::RecordInvalid)
        # end
      end

      context "when the trick has finished" do

      end

      context "when the card doesn't follow suit" do

      end
    end
  end
end
