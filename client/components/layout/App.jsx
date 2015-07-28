var React = require('react');
var GamesView = require('../games/View.jsx');

module.exports = React.createClass({
    render: function() {
        return (
            <div id="content">
              <GamesView />
            </div>
        );
    }
});
