var React = require('react');
var Actions = require('../actions');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      gameId: null,
      roundId: null,
      playerId: null,
      numberOfTricks: null,
      suit: null
    }
  },
  handleClick: function() {
    Actions.placeBid(this.props.roundId,
                      this.props.playerId,
                      this.props.numberOfTricks,
                      this.props.suit);
  },
  render: function() {
    return (
      <button onClick={this.handleClick} className={"btn submit-bid"} type="button">
        {this.props.numberOfTricks} {this.props.suit}
      </button>
    );
  }
});