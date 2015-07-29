var React = require('react');
var Reflux = require('reflux');
var Api = require('../utils/api');
var Actions = require('../actions');
var _ = require('lodash');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getRounds: function(gameId) {
    Api.get('games/' + gameId)
    .then(function(json) {
      this.rounds = json.game.rounds;
      this.triggerChange();
    }.bind(this));
  },
  getRound: function(roundId) {
    console.log('getRound called');
    Api.get('rounds/' + roundId)
      .then(function(json) {
        if(this.rounds) {
          //console.log('json: ' + json);
          this.rounds.push(json.round);
        } else {
          //console.log('storing the first round in round-store...');
          this.rounds = [json.round];
        }
        this.triggerChange();
      }.bind(this));
  },
  find: function(roundId) {
    var round = _.findWhere(this.rounds, {id: roundId});
    if(round) {
      return round
    } else {
      this.getRound(roundId);
      return null
    }
  },
  triggerChange: function() {
    this.trigger('change', this.rounds);
  }
});