var React = require('react');

module.exports = React.createClass({
  render: function() {
    return (
      <li className="card">{this.props.rank} of {this.props.suit}</li>
    );
  }
});