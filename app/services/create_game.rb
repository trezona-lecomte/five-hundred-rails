class CreateGame
  def call(number_of_teams: 2)
    game = Game.create!

    (1..number_of_teams).each do |n|
      game.teams.create!(number: n)
    end

    # game.playing_order = PlayingOrder.new

    game
  end
end