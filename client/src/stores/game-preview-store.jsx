var Api = require('../utils/api');
var Reflux = require('reflux');
var Actions = require('../actions');

module.exports = Reflux.createStore({
  listenables: [Actions],
  getGamePreviews: function() {
    return Api.get('games')
    .then(function(json) {
      this.game_previews = json.game_previews;
      this.triggerChange();
    }.bind(this));
  },
  triggerChange: function() {
    this.trigger('change', this.game_previews);
  }
});