var React = require('react');
var Card = require('./card');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      cards: [],
      playerdId: null,
      gameId: null,
      activeTrickId: null
    }
  },
  render: function() {
    playerId = this.props.playerId;
    gameId = this.props.gameId;
    console.log(this.props.activeTrickId);
    activeTrickId = this.props.activeTrickId;

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
                    trickId={activeTrickId}
                    gameId={gameId} />
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