var React = require('react');
var Card = require('./card');

module.exports = React.createClass({
  render: function() {
    console.log(this.props.cards);
    return (
      <div>
      <h4>Trick:</h4>
      {this.props.cards}
      </div>
    );
  }
  // renderTrickCards: function() {
  //   return this.state.cards.map(function(card) {
  //     return (
  //       <Link to={"cards/" + card.id} className="list-group-item" key={card.id}>
  //       <h4>Card {card.id}</h4>
  //       </Link>
  //     )
  //   });
  // }
});
