//= require jquery
//= require cable
//= require grid_animate
//= require countdown
//= require cable
//= require rails-ujs
//= require utilities
//= require notifications_menu
//= require specific_by_templates/trending_tags_bar

window.onerror = function(error, url, line) {
  sendExceptionToServer(error, url, line)
};

function sendExceptionToServer(error, url, line) {
  var source = url+' L:'+line
  $.post({
    url: '/api/v1/exceptions',
    data: { exception: error, source:  source}
  })
}
