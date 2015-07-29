var React = require('react');

module.exports = React.createClass({
  render: function() {
    return (
      <div>
        <h2>Card {this.props.id}</h2>
        <h3>{this.props.rank} of {this.props.suit}<h3>
      </div>
    );
  }
});