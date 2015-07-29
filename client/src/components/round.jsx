var React = require('react');
var Reflux = require('reflux');
var Trick = require('./trick');

module.exports = React.createClass({
  render: function() {
    return (
      <div>
          <h2>Round </h2>
          {this.renderActiveTrick()}
      </div>
    );
  },
  renderActiveTrick: function() {
    console.log('rending active trick: ');
    console.log(this.props.tricks);
    var tricks = this.props.tricks;
    if (typeof tricks !== 'undefined' && tricks.length > 0) {
      var activeTrick = tricks[tricks.length -1];
      return (
        <div>
          <Trick cards={activeTrick.cards} key={activeTrick.id}/>
        </div>
      );
    } else {
      return (
        <h4>This rounds has no tricks!</h4>
      )
    }
  }
  // renderPlayerCards: function() {
  //   return this.state.playerCards.map(function(card) {
  //     return (
  //       <li className="list-group-item" key={card.id}>
  //           <h4>Card {card.id}</h4>
  //       </li>
  //     );
  //   });
  // }
});
