//= require jquery
//= require rails-ujs
//= require action_cable
//= require turbolinks
//= require skim
//= require cocoon
//= require_tree .

let App = {} || App;
App.cable = ActionCable.createConsumer();