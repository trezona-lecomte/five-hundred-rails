var React = require('react');
var Card = require('./card');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      cards: []
    }
  },
  render: function() {
    console.log('rendering hand, card count: ' + this.props.cards.length);
    return (
      <div id="hand">
        <h3>Hand of player {this.props.playerId}</h3>
        {this.props.cards.map(function(card) {
          return (
            <div id="cards">
              <Card key={card.id} rank={card.rank} suit={card.suit} />
            </div>
          );
        })}
      </div>
    );
  }
});