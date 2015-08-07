var React        = require('react');
var Trick        = require('./trick');
var Hand         = require('./hand');
var BiddingRound = require('./bidding_round');
var PlayingRound = require('./playing_round');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      id: null,
      stage: null,
      gameId: null,
      players: [],
      bids: [],
      tricks: [],
      hands: [],
    }
  },
  render: function() {
    var roundToRender;

    if (this.props.stage === "bidding") {
      roundToRender = this.renderBiddingRound();
    } else if (this.props.stage === "playing") {
      roundToRender = this.renderPlayingRound();
    };
    return (
      <div>
        <h2>Round {this.props.id}: {this.props.stage}</h2>
        {roundToRender}
      </div>
    );
  },
  renderBiddingRound: function() {
    return (
      <BiddingRound key={this.props.id}
                    players={this.props.players}
                    bids={this.props.bids}
                    hands={this.props.hands}
                    roundId={this.props.id} />
    );
  },
  renderPlayingRound: function() {
    return (
      <PlayingRound key={this.props.id}
                    players={this.props.players}
                    bids={this.props.bids}
                    winningBid={this.props.winningBid}
                    tricks={this.props.tricks}
                    hands={this.props.hands}
                    gameId={this.props.gameId} />
    );
  },
});
