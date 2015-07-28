var React = require("react");

var GameBadge = require("./GameBadge.jsx");

module.exports = React.createClass({
    render: function() {
        var gameBadges = this.props.data.map(function(game) {
            return (
                <GameBadge key={game.id} num={game.id} />
           );
        });

        return (
            <ul className="games-list">
              <h3>GamesList:</h3>
              {gameBadges}
            </ul>
        );
    }
});
