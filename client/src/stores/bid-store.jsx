var React   = require('react');
var Reflux  = require('reflux');
var Api     = require('../utils/api');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getBids: function(roundId) {
    return Api.get('rounds/' + roundId + '/bids')
    .then(function(json) {
      this.bids = json.bids;
      this.triggerChange();
    }.bind(this));
  },
  submitBid: function(roundId, playerId, numberOfTricks, suit) {
    var body = JSON.stringify({
      round_id: roundId,
      player_id: playerId,
      number_of_tricks: numberOfTricks,
      suit: suit
    });
    return Api.post('rounds/' + roundId + '/bids', body)
    .then(function(json) {
      this.bids = json.bids;
      this.triggerChange();
    }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.bids);
  }
});