var React = require('react');
var Reflux = require('reflux');
var Api = require('../utils/api');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getCards: function(trickId) {
    Api.get('tricks/' + trickId)
      .then(function(json) {
        this.cards = json.trick.cards;
        this.triggerChange();
      }.bind(this));
  },
  triggerChange: function() {
    console.log(this.cards);
    this.trigger('change', this.cards);
  }
});