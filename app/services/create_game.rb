class CreateGame
  def call(number_of_teams: 2)
    game = Game.create!

    (1..number_of_teams).each do |n|
      game.teams.create!(number: n)
    end

    game
  end
end
