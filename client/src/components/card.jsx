var React = require('react');

module.exports = React.createClass({
  render: function() {
    return (
      <div>
        <h2>Card:</h2>
        {this.props.rank} of {this.props.suit}
      </div>
    );
  }
});