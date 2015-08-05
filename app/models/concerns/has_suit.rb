module HasSuit
  extend ActiveSupport::Concern

  included do
    enum suit: %w(spades clubs diamonds hearts no_suit)
  end
end
