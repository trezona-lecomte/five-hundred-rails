var React = require('react');
var Actions = require('../actions');

module.exports = React.createClass({
  getDefaultProps: function() {
    return {
      className: null,
      gameId: null,
      roundId: null,
      playerId: null,
      cardId: null
    }
  },
  handleClick: function() {

    Actions.playCard(this.props.gameId,
                     this.props.roundId,
                     this.props.playerId,
                     this.props.cardId);
  },
  render: function() {
    return (
      <button onClick={this.handleClick} className={"btn " + this.props.className} type="button">
        {this.props.title}
        <span className={this.props.subTitleClassName}>{this.props.subTitle}</span>
      </button>
    );
  }
});