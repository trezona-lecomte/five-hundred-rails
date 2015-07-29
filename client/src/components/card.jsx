var React = require('react');

module.exports = React.createClass({
  render: function() {
    return (
      <div>
        <h2>Card {this.props.id}</h2>
        <h3>{this.props.rank} of {this.props.suit}<h3>
      </div>
    )
  },
  renderTrickCards: function() {
    return this.state.cards.map(function(card) {
      return (
        <Link to={"cards/" + card.id} className="list-group-item" key={card.id}>
        <h4>Card {card.id}</h4>
        </Link>
      );
    });
  },
  onChange: function(event, cards) {
    this.setState({cards: cards})
  }
});