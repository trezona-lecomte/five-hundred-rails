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

  def update
    round = Round.find(game_params[:round_id])
    player = Player.find(game_params[:player_id])
    card = Card.find(game_params[:card_id])

    play_card = PlayCard.new(round, player, card)

    if play_card.call
      render :update, status: 200, locals: {errors: []}
    else
      render :update, status: 422, locals: {errors: play_card.errors}
    end
  end
  # def destroy
  #   @game.destroy

  #   head :no_content
  # end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.permit(:id, :round_id, :player_id, :card_id)
  end
end
