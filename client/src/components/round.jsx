var React = require('react');
var Trick = require('./trick');
var Hand = require('./hand');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      id: null,
      tricks: [],
      hands: []
    }
  },
  render: function() {
    return (
      <div>
          <h2>Round {this.props.id}</h2>
          {this.renderTricks()}
          {this.renderHands()}
      </div>
    );
  },
  renderTricks: function() {
    var playedCards = this.playedCards(this.props.hands);
    var tricks = this.props.tricks;
    return tricks.map(function(trick) {
      return (
        <Trick key={trick.id} id={trick.id} num={tricks.indexOf(trick) + 1} allPlayedCards={playedCards} />
      );
    });
  },
  renderHands: function() {
    var gameId = this.props.gameId;
    var roundId = this.props.id;
    return this.props.hands.map(function(hand) {
      return (
        <Hand key={hand.id}
              cards={hand.cards}
              playerId={hand.player.id}
              gameId={gameId}
              roundId={roundId}/>
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
