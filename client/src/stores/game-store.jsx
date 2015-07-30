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
  playCard: function(gameId, trickId, playerId, cardId) {
    console.log('playing card: ' + cardId)
    var body = JSON.stringify({
        trick_id: trickId,
        player_id: playerId,
        card_id: cardId
    });
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
