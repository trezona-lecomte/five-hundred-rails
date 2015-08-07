var React = require('react');
var Reflux = require('reflux');
var Api = require('../utils/api');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getAvailableBids: function(roundId) {
    return Api.get('rounds/' + roundId + '/bids')
    .then(function(json) {
      this.availableBids = json.available_bids;
      this.triggerChange();
    }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.availableBids);
  }
});