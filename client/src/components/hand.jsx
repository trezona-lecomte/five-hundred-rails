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
    playerId = this.props.playerId;
    console.log("HAND: " + JSON.stringify(this.props.cards));
    return (
      <div id="hand">
        <h3>Hand of player {this.props.playerId}</h3>
        {this.unplayedCards(this.props.cards).map(function(card) {
            return (
              <div id="card">
              <Card key={card.id}
                    id={card.id}
                    rank={card.rank}
                    suit={card.suit}
                    playerId={playerId}
                    trickId={card.trick_id} />
              </div>
            );
          })
        }
      </div>
    );
  },
  unplayedCards: function(allCards) {
    cards = [];
    allCards.filter(function(card) {
      if(!card.trick_id) {
        cards.push(card);
      }
    });
    return cards;
  }
});