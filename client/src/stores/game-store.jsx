var Api = require('../utils/api');
var Reflux = require('reflux');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getGame: function(gameId) {
    return Api.get('games/' + gameId)
    .then(function(json) {
      this.game = json;
      this.triggerChange();
    }.bind(this));
  },
  playCard: function(gameId, roundId, playerId, cardId) {
    var body = JSON.stringify({
        round_id: roundId,
        player_id: playerId,
        card_id: cardId
    });
    // TODO: change this to PATCH
    return Api.put('games/' + gameId, body)
    .then(function(json) {
      this.game = json;
      this.triggerChange();
    }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.game);
  }
});
