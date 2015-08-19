module HasSuit
  # TODO Store suits in a constant and refer to it when constructing the attr in bid and card.
  extend ActiveSupport::Concern

  included do
    enum suit: %w(spades clubs diamonds hearts no_suit)
  end
end
