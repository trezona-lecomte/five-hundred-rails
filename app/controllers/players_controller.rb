class PlayersController < ApplicationController
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
