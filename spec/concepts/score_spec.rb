require "rails_helper"

RSpec.describe Score, type: :concept do
  SCORES = {
    Card.suits[:spades] => {
      6  =>  40,
      7  => 140,
      8  => 240,
      9  => 340,
      10 => 440
    },
    Card.suits[:clubs] => {
      6  =>  60,
      7  => 160,
      8  => 260,
      9  => 360,
      10 => 460
    },
    Card.suits[:diamonds] => {
      6  =>  80,
      7  => 180,
      8  => 280,
      9  => 380,
      10 => 480
    },
    Card.suits[:hearts] => {
      6  => 100,
      7  => 200,
      8  => 300,
      9  => 400,
      10 => 500
    },
    Card.suits[:no_suit] => {
      6  => 120,
      7  => 220,
      8  => 320,
      9  => 420,
      10 => 520
    },
  }


  (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.product(Card.suits.keys).each do |n, s|

    describe "#for_successful_attack" do
      context "for #{n} #{s}" do
        let(:score) { Score.new(number_of_tricks: n, suit: s) }

        subject { score.for_successful_attack }

        it { is_expected.to eq(SCORES[Card.suits[s]][n]) }
      end
    end

    describe "#for_failed_attack" do
      context "for #{n} #{s}" do
        let(:score) { Score.new(number_of_tricks: n, suit: s) }

        subject { score.for_failed_attack }

        it { is_expected.to eq(-SCORES[Card.suits[s]][n]) }
      end
    end
  end

  describe "#for_defense" do
    (1..10).to_a.each do |n|

      context "for #{n} tricks" do
        let(:score) { Score.new(number_of_tricks: n) }

        subject { score.for_defense }

        it { is_expected.to eq(n * 10) }
      end
    end
  end
end
