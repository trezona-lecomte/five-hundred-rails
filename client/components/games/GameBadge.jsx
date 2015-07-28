var React = require('react');
var Router = require("react-router");
var Link = Router.Link

module.exports = React.createClass({
    render: function() {
        return (
            <li className="game-badge">
            <Link to="game" params={{gameId: this.props.num}}>Game {this.props.num}</Link>
            </li>
        );
    }
});
