var React = require("react");
var Reqwest = require("reqwest");
var GamesView = require("../games/View.jsx");
var Menu = require("./Menu.jsx");
var Router = require("react-router");
var RouteHandler = Router.RouteHandler;

module.exports = React.createClass({
    getDefaultProps: function() {
        return {origin: process.env.NODE_ENV === "development" ? "http://localhost:3000" : "" };
    },
    getInitialState: function() {
        return {showMenu: false};
    },
    handleMenuClick: function() {
        this.setState({showMenu: !this.state.showMenu});
    },
    readFromAPI: function(url, successFunction) {
        Reqwest({
            url: url,
            type: "json",
            method: "get",
            contentType: "application/json",
            success: successFunction,
            error: function(error) {
                console.error(url, error["response"]);
                location = "/";
            }
        });
    },
    writeToAPI: function(method, url, data, successFunction) {
        Reqwest({
            url: url,
            data: data,
            type: "json",
            method: method,
            contentType: "application/json",
            //headers: {"Authorization": sessionStorage.getItem("jwt")},
            success: successFunction,
            error: function(error) {
                console.error(url, error["response"]);
                location = "/";
            }
        });
    },
    render: function() {
        var menu = this.state.showMenu ? "show-menu" : "hide-menu";

        return (
            <div id="app" className={menu}>
              <Menu origin={this.props.origin} sendMenuClick={this.handleMenuClick} />
              <div id="content">
                <RouteHandler origin={this.props.origin} writeToAPI={this.writeToAPI} readFromAPI={this.readFromAPI} />
              </div>
            </div>
        );
    }
});
