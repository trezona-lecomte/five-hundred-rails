var React = require('react');
var Card = require('./card');

module.exports = React.createClass({
  render: function() {
    console.log('rending a hand');
    var cards = this.props.cards;
    if (typeof cards !== 'undefined' && cards.length > 0) {
      return this.props.cards.map(function(card) {
        <Card key={card.id} rank={card.rank} suit={card.suit} />
      });
    }
  }
});
