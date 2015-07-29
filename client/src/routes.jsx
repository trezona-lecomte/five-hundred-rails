var React = require('react');
var ReactRouter = require('react-router');
var HashHistory = require('react-router/lib/hashhistory');
var Router = ReactRouter.Router
var Route = ReactRouter.Route

var Main = require('./components/main');
var Game = require('./components/game');
var Round = require('./components/round');
var Trick = require('./components/trick');

module.exports = (
  <Router history={new HashHistory}>
    <Route path="/" component={Main}>
      <Route path="games/:id" component={Game} />
      <Route path="rounds/:id" component={Round} />
      <Route path="tricks/:id" component={Trick} />
    </Route>
  </Router>
)