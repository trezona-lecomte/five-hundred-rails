var React = require('react');
var Reflux = require('reflux');
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
          <h2>Round </h2>
          {this.renderTricks()}
          {this.renderHands()}
      </div>
    );
  },
  renderTricks: function() {
    console.log('rendering tricks');
    return this.props.tricks.map(function(trick) {
      <Trick num={trick.id} key={trick.id} />
    });
  },
  renderHands: function() {
    console.log('rending hands');
    return this.props.hands.map(function(hand) {
      <Hand cards={hand.cards} key={hand.id} />
    });
  }
});
