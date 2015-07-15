class PlayCard
  attr_reader :round, :player, :card, :trick

  def initialize(round:, player:)
    @round = round
    @player = player
  end

  def call(card:, trick:)

  end
end
