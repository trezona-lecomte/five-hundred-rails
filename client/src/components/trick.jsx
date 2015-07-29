var React = require('react');
var Reflux = require('reflux');
var Actions = require('../actions');
var ReactRouter = require('react-router');
var Link = ReactRouter.Link;
var Card = require('./card');
var CardStore = require('../stores/card-store');

module.exports = React.createClass({
  mixins: [
    Reflux.listenTo(CardStore, 'onChange')
  ],
  getInitialState: function() {
    return {cards: []}
  },
  componentWillMount: function() {
    Actions.getCards(this.props.params.id);
  },
  componentWillReceiveProps: function(nextProps) {
    Actions.getCards(nextProps.params.id);
  },
  render: function() {
    return <div>
    <h2>Trick {this.props.id}</h2>
        {this.renderTrickCards()}
      </div>
  },
  renderTrickCards: function() {
    return this.state.cards.map(function(card) {
      return (
        <Link to={"cards/" + card.id} className="list-group-item" key={card.id}>
        <h4>Card {card.id}</h4>
        </Link>
      );
    });
  },
  onChange: function(event, cards) {
    this.setState({cards: cards})
  }
});
