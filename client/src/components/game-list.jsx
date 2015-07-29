var React = require('react');
var Reflux = require('reflux');
var GamePreviewStore = require('../stores/game-preview-store');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(GamePreviewStore, 'onChange')
  ],
  getInitialState: function() {
    return {gamePreviews: []}
  },
  componentWillMount: function() {
    Actions.getGamePreviews();
  },
  render: function() {
    return (
      <div className="list-group">
      Game List
      {this.renderGamePreviews()}
      </div>
    );
  },
  renderGamePreviews: function() {
    return this.state.gamePreviews.map(function(game) {
      return (
        <Link to={"games/" + game.id} className="list-group-item" key={game.id}>
        <h4>Game {game.id}</h4>
        </Link>
      );
    });
  },
  onChange: function(event, gamePreviews) {
    this.setState({gamePreviews: gamePreviews})
  }
});