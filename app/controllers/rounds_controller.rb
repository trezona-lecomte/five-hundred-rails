class RoundsController < ApplicationController
  before_action :set_round, only: [:show]

  def show
    render json: @round
  end

  def index
    @rounds = Round.all

    render json: @rounds
  end

  def create
    @game = Game.find(round_params[:game_id])

    @round = @game.rounds.new

    deal_cards = DealCards.new(@game, @round)

    if deal_cards.call
      render json: @round, status: :created
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def show
    @round = Round.find(params[:id])

    render json: @round
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end

  def round_params
    params.permit(:game_id)
  end
end
