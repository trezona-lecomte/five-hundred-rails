var React = require('react');
var Reflux = require('reflux');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;
var GameStore = require('../stores/game-store');
var Round = require('./round');

var renderCount = 0;

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(GameStore, 'onChange')
  ],
  getInitialState: function() {
    return {
      players: [],
      rounds: []
    }
  },
  componentWillMount: function() {
    Actions.getGame(this.props.params.id);
  },
  render: function() {

    return (
      <div>
      <h2>Game {this.props.params.id}</h2>
        {this.displayPlayerErrors()}
        {this.renderRounds()}
      </div>
    )
  },
  renderRounds: function() {

    var gameId = this.props.params.id;
    return (
      <div id="rounds">
        {this.state.rounds.map(function(round) {
          return (
            <div id="round">
            <Round key={round.id}
                   tricks={round.tricks}
                   hands={round.hands}
                   id={round.id}
                   gameId={gameId}/>
            </div>
          );
        })}
      </div>
      );
  },
  onChange: function(event, game) {
    this.setState({
      players: game.players,
      rounds: game.rounds
    });
  },
  displayPlayerErrors: function() {
    this.state.players.map(function(player) {
      if(typeof player.errors !== 'undefined' && player.errors.length > 0) {

        return (
          <div id="errors">
            <h5>Error: </h5>
            {player.errors[0]}
          </div>
        );
      }
    });
  }
});
