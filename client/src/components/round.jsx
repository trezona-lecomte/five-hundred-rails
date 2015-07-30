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
    return this.props.tricks.map(function(trick) {
      return (
        <Trick key={trick.id} num={trick.id} />
      );
    });
  },
  renderHands: function() {
    console.log('rendering hands, count: ' + this.props.hands.length);
    return this.props.hands.map(function(hand) {
      console.log('hand: ' + hand.id + ' rendered');
      return (
        <Hand key={hand.id} cards={hand.cards} playerId={hand.player_id} />
      );
    });
  }
});
