var React = require('react');
var Reflux = require('reflux');
var Api = require('../utils/api');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getRounds: function(gameId) {
    Api.get('games/' + gameId)
      .then(function(json) {
        this.rounds = json.game.rounds;
        this.triggerChange();
      }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.rounds);
  }
});