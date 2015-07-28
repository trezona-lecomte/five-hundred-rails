var React = require("react");
var GamesList = require("./List.jsx");
var GamesForm = require("./Form.jsx");

module.exports = React.createClass({
    getInitialState: function() {
        return {data: []};
    },
    componentDidMount: function() {
        this.readGamesFromAPI();
    },
    readGamesFromAPI: function() {
        this.props.readFromAPI(this.props.origin + "/games", function(game_data) {
            this.setState({data: game_data.games});
        }.bind(this));
    },
    writeGameToAPI: function(data) {
        this.props.writeToAPI("post", this.props.origin + "/games", data, function(game) {
            var games = this.state.data;
            games.shift();
            games.unshift(game);
            this.setState({data: games});
        }.bind(this));
    },
    optimisticUpdate: function(game) {
        var games = this.state.data;
        games.unshift(game);
        this.setState({data: games});
    },
    render: function() {
        return (
            <div className="games-view">
              <h2>GamesView:</h2>
              <GamesForm writeGameToAPI={this.writeGameToAPI} optimisticUpdate={this.optimisticUpdate} />
              <GamesList data={this.state.data} />
            </div>
        );
    }
});
