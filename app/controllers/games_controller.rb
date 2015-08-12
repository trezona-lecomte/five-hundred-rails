class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]
  skip_before_action :authenticate_user_from_token!, only: [:index]
  # TODO: handle unauthenticated users viewing games (no current_user)

  def index
    @games = Game.all

    render json: @games
  end

  def show
    render json: @game
  end

  def create
    @game = Game.new

    join_game = JoinGame.new(@game, current_user)
    join_game.call

    if join_game.errors.present?
      render json: { errors: join_game.errors }, status: :unprocessable_entity
    else
      if @game.save
        render json: @game, status: :created, location: @game
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.permit(:id, :round_id, :player_id, :card_id)
  end
end
