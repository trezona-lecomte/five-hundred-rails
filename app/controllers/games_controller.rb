class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
    games = Game.all

    render json: games, each_serializer: GamePreviewSerializer
  end

  def show
    render json: @game
  end

  def create
    game = Game.new

    if game.save
      render json: game, status: :created, location: game
    else
      render json: game.errors, status: :unprocessable_entity
    end
  end

  # def update
  #   @game = Game.find(params[:id])

  #   if @game.update(game_params)
  #     head :no_content
  #   else
  #     render json: @game.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @game.destroy

  #   head :no_content
  # end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
