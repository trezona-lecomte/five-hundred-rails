var React     = require('react');
var Reflux    = require('reflux');
var BidStore  = require('../stores/bid-store');
var Actions   = require('../actions');
var BidButton = require('./bid-button');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(BidStore, 'onChange')
  ],
  getDefaultProps: function() {
    return {
      roundId: null,
      availableBids: [
        { numberOfTricks: 0, suit: "no_suit" },
        { numberOfTricks: 6, suit: "spades"  },
        { numberOfTricks: 6, suit: "clubs"  },
        { numberOfTricks: 6, suit: "diamonds"  },
        { numberOfTricks: 6, suit: "hearts"  },
        { numberOfTricks: 6, suit: "no_suit"  },
        { numberOfTricks: 7, suit: "spades"  },
        { numberOfTricks: 7, suit: "clubs"  },
        { numberOfTricks: 7, suit: "diamonds"  },
        { numberOfTricks: 7, suit: "hearts"  }
      ]
    }
  },
  getInitialState: function() {
    return {
      bids: []
    }
  },
  componentWillMount: function() {
    Actions.getBids(this.props.roundId);
  },
  render: function() {
    return (
      <div>
        <div id="existing-bids" className="list-group">
          Bids:
          {this.renderBids()}
        </div>
        <div id="bid-options" className="list-group">
          Place bid:
          {this.renderBidOptions()}
        </div>
      </div>
    );
  },
  renderBids: function() {
    console.log("number of tricks:" + JSON.stringify(this.state.bids));
    return this.state.bids.map(function(bid) {
      return (
        <h5>{bid.number_of_tricks} of {bid.suit} - player {bid.player_id}</h5>
      );
    });
  },
  renderBidOptions: function() {
    var roundId = this.props.roundId;

    return this.props.availableBids.map(function(bid) {
      return (
        <BidButton key={bid.numberOfTricks + bid.suit}
                   playerId={2}
                   roundId={roundId}
                   numberOfTricks={bid.numberOfTricks}
                   suit={bid.suit} />
       );
    });
  },
  onChange: function(event, bids) {
    this.setState({
      bids: bids
    })
  }
});
