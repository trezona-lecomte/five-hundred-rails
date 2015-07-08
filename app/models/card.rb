class Card
  include Comparable
  attr_reader :number, :suit

  def initialize(number, suit)
    @number = number
    @suit = suit
  end

  def play
    @played = true
    self
  end

  def played?
    @played
  end
end