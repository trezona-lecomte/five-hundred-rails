var React = require("react");

module.exports = React.createClass({
    handleSubmit: function(e) {
       this.props.writeGameToAPI(JSON.stringify({game: { }}));
    },
    render: function() {
        return (
            <form className="games-form pure-form" onSubmit={this.handleSubmit}>
              <button type="submit" className="pure-button pure-button-primary">New Game</button>
            </form>
        );
    }
});
