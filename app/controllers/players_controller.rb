class PlayersController < ApplicationController
  before_action :set_game, only: [:index]

  def index
    @players = @game.players

    render json: @players, each_serializer: PlayerPreviewSerializer
  end

  def show
    @player = Player.find(params[:id])

    if @player.user == current_user
      render json: @player
    else
      render json: { errors: ["you are not authorized to view this player"] }
    end
  end

  def create
    @game = Game.find(player_params[:game_id])

    join_game = JoinGame.new(game: @game, user: current_user)

    if join_game.call
      render json: @game, status: :created
    else
      render json: { errors: [join_game.errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.preload(:players).find(params[:game_id])
  end

  def player_params
    params.permit(:game_id, :handle)
  end
end
