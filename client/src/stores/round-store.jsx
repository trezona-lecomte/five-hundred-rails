var React = require('react');
var Api = require('../utils/api');
var Actions = require('../actions');
var Reflux = require('reflux');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getRounds: function(gameId) {
    Api.get('games/' + gameId)
      .then(function(json) {
        this.rounds = json.data;
        this.triggerChange();
      }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.rounds);
  }
});