var React = require('react');
var GamesList = require('./List.jsx');

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
    render: function() {
        return (
            <div className="games-view">
              <GamesList data={this.state.data} />
            </div>
        );
    }
});
