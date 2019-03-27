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

$('.card-vote').on('click', function(e){
  e.preventDefault();
  $('.card-vote').parents('.card-fight').addClass('card-fight-selected')
  $('.divider-button, .divider-button-mobile').removeClass('hidden')
})
$('.divider-button, .divider-button-mobile').on('click', function(e){
  e.preventDefault();
  $(this).addClass('hidden')
  $('.card-fight').removeClass('card-fight-selected')
})



