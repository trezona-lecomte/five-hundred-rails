var React = require('react');
var Reflux = require('reflux');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;
//var Round = require('./round');
var RoundStore = require('../stores/round-store');
var TrickStore = require('../stores/trick-store');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(RoundStore, 'onChange'),
    Reflux.listenTo(RoundStore, 'onChange')
  ],
  getInitialState: function() {
    return {
      rounds: []
    }
  },
  componentWillMount: function() {
    Actions.getRounds(this.props.params.id);
  },
  componentWillReceiveProps: function(nextProps) {
    Actions.getRounds(nextProps.params.id);
  },
  render: function() {
    return <div>
    <h2>Game {this.props.params.id}</h2>
    {this.renderRoundPreviews()}
    </div>
  },
  renderRoundPreviews: function() {
    return this.state.rounds.map(function(round) {
      return (
        <Link to={"rounds/" + round.id} className="list-group-item" key={round.id}>
        <h4>Round {round.id}</h4>
        </Link>
      );
    });
  },
  onChange: function(event, rounds) {
    rounds: this.setState({rounds: rounds})
  }
});
