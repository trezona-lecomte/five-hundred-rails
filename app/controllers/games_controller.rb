class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
    @games = Game.all
  end

  def show
    # method left blank - before_action handles setting @game
  end

  def create
    game = Game.new

    if game.save
      render json: game, status: :created, location: game
    else
      render json: game.errors, status: :unprocessable_entity
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
