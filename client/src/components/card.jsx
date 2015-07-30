var React = require('react');
var Button = require('./button');

module.exports = React.createClass({
  render: function() {
    return (
      <div className="card">
        <Button
          gameId={this.props.gameId}
          roundId={this.props.roundId}
          playerId={this.props.playerId}
          cardId={this.props.id}
          className="btn-default"
          title={this.props.rank + " of " + this.props.suit}
        />
      </div>

      // <li className="card">{this.props.rank} of {this.props.suit}</li>
    );
  }
});