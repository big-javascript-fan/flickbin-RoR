//= require jquery
//= require countdown
//= require wow.min
//= require rails-ujs
//= require utilities
//= require notifications_menu
//= require specific_by_templates/trending_tags_bar

new WOW().init();

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