var React = require('react');
var Reflux = require('reflux');
var Api = require('../utils/api');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getTricks: function(roundId) {
    Api.get('rounds/' + roundId)
      .then(function(json) {
        this.tricks = json.round.tricks;
        this.triggerChange();
      }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.tricks);
  }
});