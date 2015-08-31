class RoundsController < ApplicationController
  before_action :set_round,  only: [:show]

  def index
    @rounds = Round.all

    render json: @rounds
  end

  def show
    @round.with_lock do
      render json: @round
    end
  end

  private

  def set_round
    puts "Entering: set_round"
    @round = Round.preload(:bids, game: [:players]).find(params[:id])
  end
end
