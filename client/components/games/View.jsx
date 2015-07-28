var React = require('react');
var GamesList = require('./List.jsx');

module.exports = React.createClass({
    getInitialState: function() {
        return {data: []};
    },
    componentDidMount: function() {
        this.setState({data: [{id: 1, num: 1}, {id: 2, num: 2}]});
    },
    render: function() {
        return (
            <div className="games-view">
              <GamesList data={this.state.data} />
            </div>
        );
    }
});
