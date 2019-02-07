//= require jquery
//= require rails-ujs
//= require utilities
//= require notifications_menu
//= require specific_by_templates/trending_tags_bar

$(function() {
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
});