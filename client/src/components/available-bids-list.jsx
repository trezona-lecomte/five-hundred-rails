var React              = require('react');
var Reflux             = require('reflux');
var Actions            = require('../actions');
var AvailableBid       = require('./available-bid');
var AvailableBidsStore = require('../stores/available-bids-store');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(AvailableBidsStore, 'onChange')
  ],
  getDefaultProps: function() {
    return {
      roundId: null
    }
  },
  getInitialState: function() {
    return {
      availableBids: []
    }
  },
  componentWillMount: function() {
    Actions.getAvailableBids(this.props.roundId)
  },
  render: function() {
    return (
      <div id="available-bids" className="list-group">
        Place bid:
        {this.renderAvailableBids()}
      </div>
    );
  },
  // TODO: use query params to set the current player!
  renderAvailableBids: function() {
    var roundId = this.props.roundId;

    return this.state.availableBids.map(function(bid) {
      console.log("BID: " + JSON.stringify(bid));
      return (
        <AvailableBid key={bid.number_of_tricks.toString() + bid.suit}
                      playerId={3}
                      roundId={roundId}
                      numberOfTricks={bid.number_of_tricks}
                      suit={bid.suit} />
      );
    });
  },
  onChange: function(event, availableBids) {
    this.setState({
      availableBids: availableBids
    })
  }
});