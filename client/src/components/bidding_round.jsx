var React   = require('react');
var AvailableBidsList = require('./available-bids-list');
var PlacedBidsList = require('./placed-bids-list');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      roundId: null
    }
  },
  render: function() {
    return (
      <div id="bidding-round">
        <PlacedBidsList roundId={this.props.roundId} />
        <AvailableBidsList roundId={this.props.roundId} />
      </div>
    );
  }
});