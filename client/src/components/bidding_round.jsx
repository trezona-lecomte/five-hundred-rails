var React   = require('react');
var BidList = require('./bid-list');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      roundId: null,
      bids: []
    }
  },
  render: function() {
    return (
      <BidList roundId={this.props.roundId}/>
    );
  }
});