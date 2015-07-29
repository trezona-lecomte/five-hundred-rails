var React = require('react');
var Reflux = require('reflux');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;
var Trick = require('./trick');
var TrickStore = require('../stores/trick-store');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(TrickStore, 'onChange')
  ],
  getInitialState: function() {
    return {tricks: []}
  },
  componentWillMount: function() {
    Actions.getTricks(this.props.params.id);
  },
  componentWillReceiveProps: function(nextProps) {
    Actions.getTricks(nextProps.params.id);
  },
  render: function() {
    return (
      <div>
      <h2>Round {this.props.id}</h2>
      {this.renderTrickPreviews()}
      </div>
    )
  },
  renderTrickPreviews: function() {
    return this.state.tricks.map(function(trick) {
      return (
        <Link to={"tricks/" + trick.id} className="list-group-item" key={trick.id}>
        <h5>Trick {trick.id}</h5>
        </Link>
      );
    });
  },
  onChange: function(event, tricks) {
    this.setState({tricks: tricks})
  }
});