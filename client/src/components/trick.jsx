var React = require('react');
var Card = require('./card');

module.exports = React.createClass({
  render: function() {
    return (
      <div>
        <h4>Trick {this.props.id}</h4>
        {this.cardsInTrick(this.props.allPlayedCards, this.props.id).map(function(card) {
            return (
              <div id="card">
              <Card key={card.id}
                    id={card.id}
                    rank={card.rank}
                    suit={card.suit} />
              </div>
            );
        })}
      </div>
    );
  },
  cardsInTrick: function(playedCards, trickId) {
    cards = [];
    playedCards.filter(function(card) {
      if(card.trick_id === trickId) {
        cards.push(card);
      }
    });
    return cards;
  }
});
