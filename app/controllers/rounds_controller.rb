class RoundsController < ApplicationController
  before_action :set_round,  only: [:show, :update]
  before_action :set_player, only: [:update]
  before_action :set_card,   only: [:update]

  def index
    @rounds = Round.all

    render json: @rounds
  end

  def show
    @round.with_lock do
      render json: @round
    end
  end

  def update
    play_card = PlayCard.new(
      round: @round,
      player: @player,
      card: @card
    )

    # TODO need to remove errors on successful requests!
    if play_card.call
      if @round.finished?
        score_round = ScoreRound.new(@round)

        if score_round.call
          render json: score_round.round, serializer: RoundSerializer, status: 200, locals: { errors: [] }

          start_next_round
        else
          render json: { errors: score_round.errors }, status: 422
        end
      else
        render json: play_card.round, serializer: RoundSerializer, status: 200, locals: { errors: [] }
      end
    else
      render json: { errors: play_card.errors }, status: 422
    end
  end

  private

  def start_next_round
    start_round = StartRound.new(game: @round.game)
    start_round.call
  end

  def set_round
    puts "Entering: set_round"
    @round = Round.find(params[:id])
  end

  def set_player
    @player = Player.find_by(user: current_user)
  end

  def set_card
    @card = Card.find(round_params[:card_id])
  end

  def round_params
    params.permit(:card_id)
  end
end
