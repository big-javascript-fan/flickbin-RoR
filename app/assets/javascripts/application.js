//= require jquery
//= require countdown
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



window.twttr = (function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0],
    t = window.twttr || {};
  if (d.getElementById(id)) return t;
  js = d.createElement(s);
  js.id = id;
  js.src = "https://platform.twitter.com/widgets.js";
  fjs.parentNode.insertBefore(js, fjs);

  t._e = [];
  t.ready = function(f) {
    console.log(f)
    t._e.push(f);
  };

  return t;
}(document, "script", "twitter-wjs"));