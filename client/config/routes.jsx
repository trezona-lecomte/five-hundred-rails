var React = require('react');
var Router = require('react-router');
var App = require('../components/layout/App.jsx');
var GamesView = require('../components/games/View.jsx');
var RulesView = require('../components/static/RulesView.jsx');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;

module.exports = (
  <Route name="app" path="/" handler={App}>
    <DefaultRoute name="games" handler={GamesView} />
    <Route name="rules" handler={RulesView} />
  </Route>
);
