var React = require('react');

module.exports = React.createClass({
    render: function() {
        return (
            <li className="game">
              <span className="game-num">{this.props.num}</span>
            </li>
        );
    }
});