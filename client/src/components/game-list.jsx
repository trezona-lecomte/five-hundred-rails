var React = require('react');
var Reflux = require('reflux');
var GameStore = require('../stores/game-store');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(GameStore, 'onChange')
  ],
  getInitialState: function() {
    return {games: []}
  },
  componentWillMount: function() {
    Actions.getGames();
  },
  render: function() {
    return <div className="list-group">
      Game List
      {this.renderGames()}
    </div>
  },
  renderGames: function() {
    return this.state.games.map(function(game) {
      return <Link to={"games/" + game.id} className="list-group-item" key={game.id}>
        <h4>Game {game.id}</h4>
      </Link>
    });
  },
  onChange: function(event, games) {
    this.setState({games: games});
  }
});