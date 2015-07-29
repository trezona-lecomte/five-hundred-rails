var React = require('react');
var Reflux = require('reflux');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;
var RoundStore = require('../stores/round-store');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(RoundStore, 'onChange')
  ],
  getInitialState: function() {
    return {
      round: null
    }
  },
  componentWillMount: function() {
    console.log('calling getRound from Round#componentWillMount...')
    Actions.getRound(this.props.params.id);
  },
  render: function() {
    return (
      <div>
          <h2>Round {this.props.params.id}</h2>
          <p>status: {this.state}</p>
      </div>
    );
  },
  renderPlayerCards() {
    return this.state.playerCards.map(function(card) {
      return (
        <li className="list-group-item" key={card.id}>
            <h4>Card {card.id}</h4>
        </li>
      );
    });
  },
  onChange: function() {
    this.setState({
      round: RoundStore.find(this.props.params.id)
    });
  }
});
