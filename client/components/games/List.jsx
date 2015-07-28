var React = require('react');
var Game = require('./Game.jsx');

module.exports = React.createClass({
    render: function() {
        var games = this.props.data.map(function(game) {
            return (
                <Game key={game.id} num={game.id}/>
           );
        });

        return (
            <ul className="games-list">
              {games}
            </ul>
        );
    }
});
