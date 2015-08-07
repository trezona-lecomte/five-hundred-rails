var React              = require('react');
var Reflux             = require('reflux');
var Actions            = require('../actions');
var PlacedBidsStore    = require('../stores/placed-bids-store');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(PlacedBidsStore, 'onChange')
  ],
  getDefaultProps: function() {
    return {
      roundId: null
    }
  },
  getInitialState: function() {
    return {
      placedBids: []
    }
  },
  componentWillMount: function() {
    Actions.getPlacedBids(this.props.roundId);
  },
  render: function() {
    return (
      <div id="existing-bids" className="list-group">
        Current bids:
        {this.renderPlacedBids()}
      </div>
    );
  },
  renderPlacedBids: function() {
    return this.state.placedBids.map(function(bid) {
      return (
        <h5>{bid.number_of_tricks} of {bid.suit} - player {bid.player_id}</h5>
      );
    });
  },
  onChange: function(event, placedBids) {
    this.setState({
      placedBids: placedBids
    })
  }
});
