var React = require('react');
var Card = require('./card');

module.exports = React.createClass({
  render: function() {
    return (
      <div>
      <h4>Trick: {this.props.num}</h4>
      </div>
    );
  }
});
