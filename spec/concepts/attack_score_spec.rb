require "rails_helper"

describe AttackScore, type: :concept do
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

    describe "#score" do
      context "when the attack was successful" do
        context "for #{n} #{s}" do
          let(:attack_score) { AttackScore.new(attempted_number_of_tricks: n,
                                        attempted_suit: s,
                                        number_of_tricks_won: n) }

          subject { attack_score.score }

          it { is_expected.to eq(SCORES[Card.suits[s]][n]) }
        end
      end

      context "when the attack failed" do
        context "for #{n} #{s}" do
          let(:attack_score) { AttackScore.new(attempted_number_of_tricks: n,
                                        attempted_suit: s,
                                        number_of_tricks_won: n - rand(1..10)) }

          subject { attack_score.score }

          it { is_expected.to eq(-SCORES[Card.suits[s]][n]) }
        end
      end
    end
  end
end
