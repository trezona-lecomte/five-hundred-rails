var Fetch = require('whatwg-fetch');
var rootUrl = 'http://localhost:3000/';

module.exports = {
  get: function(url) {
    return fetch(rootUrl + url, {
      headers: {

      }
    })
    .then(function(response){
      return response.json()
    });
  },
  put: function(url) {
    return fetch(rootUrl + url, {
      method: 'put',
      body:
    }
    })
  .then(function(response){

  });
};
