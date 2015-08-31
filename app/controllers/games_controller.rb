class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]
  skip_before_action :authenticate_user_from_token!, only: [:index]

  def index
    @games = Game.all

    render json: @games, each_serializer: GamePreviewSerializer
  end

  def show
    render json: @game
  end

  def create
    @game = Game.create!

    join_game = JoinGame.new(game: @game, user: current_user)
    join_game.call

    if join_game.errors.present?
      render json: { errors: join_game.errors }, status: :unprocessable_entity
    else
      render json: @game, status: :created, location: @game
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
