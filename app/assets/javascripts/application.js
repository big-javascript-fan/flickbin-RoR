//= require jquery
//= require rails-ujs
//= require utilities
//= require notifications_menu
//= require specific_by_templates/trending_tags_bar

$(function() {
  window.onerror = function(error, url, line) {
    sendExceptionToServer(error, url, line)
  };

  window.scrollDownAnimation =  function () {
    var elementForScrollDown = $(window.location.hash);

    if(elementForScrollDown.length > 0 && window.location.hash == '#message') {
      $('html, body').animate({
        scrollTop: elementForScrollDown.offset().top - 300
      }, 250);
      elementForScrollDown.addClass('is-fade');
      history.replaceState(null, null, ' ');
    }
  }

  function sendExceptionToServer(error, url, line) {
    var source = url+' L:'+line
    $.post({
      url: '/api/v1/exceptions',
      data: { exception: error, source:  source}
    })
  }
})

