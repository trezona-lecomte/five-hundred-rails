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
  // componentWillReceiveProps: function(nextProps) {
  //   Actions.getGame(nextProps.params.id);
  // },

  render: function() {
    console.log("Game render count: " + ++renderCount)
    return (
      <div>
      <h2>Game {this.props.params.id}</h2>
        {this.renderRounds()}
      </div>
      )
  },
  renderRounds: function() {
    return this.state.rounds.map(function(round) {
      return (
        <div>
          <Round tricks={round.tricks} hands={round.hands} key={round.id} />
        </div>
      );
    });
  },
  onChange: function(event, game) {
    this.setState({
      players: game.players,
      rounds: game.rounds
    });
    console.log('just got game: ' + this.state);
    console.log('got ' + this.state.rounds.length + ' rounds');
    console.log('got ' + this.state.players.length + ' players');
    console.log('got ' + this.state.rounds[0].hands.length + ' hands');
    console.log('got ' + this.state.rounds[0].tricks.length + ' tricks');
  }
});
