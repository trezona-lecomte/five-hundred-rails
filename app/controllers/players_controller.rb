class PlayersController < ApplicationController
  def index
    @game = Game.find(player_params[:game_id])
    @players = @game.players.all

    render json: @players
  end

  def show
    @player = Player.find(params[:id])

    if @player.user == current_user
      render json: @player
    else
      render json: { error: "you are not authorized to view this player" }
    end
  end

  def create
    @game = Game.find(player_params[:game_id])

    join_game = JoinGame.new(@game, player_params[:handle])

    if join_game.call
      render json: @game, status: :created
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end
  private

  def player_params
    params.permit(:game_id, :handle)
  end
end
