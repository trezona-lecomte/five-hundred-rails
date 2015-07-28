var React = require("react");

module.exports = React.createClass({
    getInitialState: function() {
        return {data: []};
    },
    componentDidMount: function() {
        // from the path '/games/:id'
        console.log(this.props.params);
        var id = this.props.params.gameId;
        readGameFromAPI(id)
    },
    readGameFromAPI: function(id) {
        this.props.readFromAPI(this.props.origin + "/games" + id, function(game_data) {
            this.setState({data: game_data});
        }.bind(this));
    },
    render: function() {
        var game = this.state.data
        return (
            <div className="game">
              <h2>Game:</h2>
              {game}
            </div>
        );
    }
});