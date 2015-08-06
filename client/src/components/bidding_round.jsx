var React = require('react');
var Bid   = require('./bid');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      bids: []
    }
  },
  render: function() {
    return (
      <div>
        <h3>Bids:</h3>
        {this.renderBids}
      </div>
    );
  },
  renderBids: function() {
    return this.props.bids.map(function(bid) {
      return (
        <Bid key={bid.id}
             id={bid.id}
             playerId={bid.player_id}
             numberOfTricks={bid.number_of_tricks}
             suit={bid.suit} />
      );
    });
  }
});