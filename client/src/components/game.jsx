var React = require('react');
var Actions = require('../actions');
var RoundStore = require('../stores/round-store');
var Reflux = require('reflux');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(RoundStore, 'onChange')
  ],
  getInitialState: function() {
    return {rounds: []}
  },
  componentWillMount: function() {
    Actions.getRounds(this.props.params.id);
  },
  render: function() {
    return <div>
      {this.state.rounds}
    </div>
  },
  onChange: function(event, rounds) {
    this.setState({rounds: rounds});
  }
});