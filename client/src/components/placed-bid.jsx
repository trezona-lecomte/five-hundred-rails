var React = require('react');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      id: null,
      playerId: null,
      numberOfTricks: null,
      suit: null
    }
  },
  render: function() {
    return (
      <div className="bid list-group-item">
        <h4>Bid {this.props.id}</h4>
        <p>Player: {this.props.playerId}</p>
        <p>{this.props.numberOfTricks} {this.props.suit}</p>
      </div>
    );
  }
});
