var React = require('react');
var Trick = require('./trick');
var Hand = require('./hand');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      tricks: [],
      hands: []
    }
  },
  render: function() {
    return (
      <div>
          <h2>Round {this.props.num}</h2>
          {this.renderTricks()}
          {this.renderHands()}
      </div>
    );
  },
  renderTricks: function() {
    console.log('rendering tricks, count: ' + this.props.tricks.length);
    var playedCards = this.playedCards(this.props.hands);
    return this.props.tricks.map(function(trick) {
      return (
        <Trick key={trick.id} id={trick.id} allPlayedCards={playedCards} />
      );
    });
  },
  renderHands: function() {
    return this.props.hands.map(function(hand) {
      return (
        <Hand key={hand.id} cards={hand.cards} playerId={hand.player_id} />
      );
    });
  },
  playedCards: function(hands) {
    cards = [];
    hands.map(function(hand) {
      hand.cards.filter(function(card) {
        if (card.trick_id) {
          cards.push(card);
        }
      });
    });
    return cards;
  }
});
