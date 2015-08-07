var Fetch = require('whatwg-fetch');
var rootUrl = 'http://localhost:3000/';

module.exports = {
  get: function(url) {
    return fetch(rootUrl + url, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(function(response){
      return response.json()
    });
  },
  post: function(url, body) {
    return fetch(rootUrl + url, {
      method: 'post',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: body
    })
    .then(function(response){
      return response.json()
    });
  },
  // TODO: change this to PATCH
  put: function(url, body) {
    return fetch(rootUrl + url, {
      method: 'put',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: body
    })
    .then(function(response){
      return response.json()
    });
  }
};
