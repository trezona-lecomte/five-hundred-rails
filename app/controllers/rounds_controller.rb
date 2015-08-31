class RoundsController < ApplicationController
  before_action :set_game,   only: [:index]
  before_action :set_round,  only: [:show]

  def index
    render json: @game.rounds, each_serializer: RoundPreviewSerializer
  end

  def show
    render json: @round
  end

  private

  def set_game
    @game = Game.preload(:rounds).find(params[:game_id])
  end

  def set_round
    @round = Round.preload(game: [:players]).find(params[:id])
  end
end
