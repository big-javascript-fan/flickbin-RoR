$(function() {
  channelSlug = $('.upDownOptions').attr('channelSlug');

  $('span.counterOption').on('click', function(e) {
    var voteValue = $(this).hasClass('upVote') ? 1 : -1

    if($(this).attr('loginRequired')) {
      window.location = '/users/sign_in'
    } else if($(this).attr('voted')){

    } else {
      $.post({
        url: `/api/v1/${channelSlug}/votes`,
        data: { value: voteValue }
      }).done(function(response, statusText, xhr) {
        $('.counterValueHolder').text(response.new_rank);
      }).fail(function(response, statusText, xhr) {
        alert(response.responseJSON.messages);
      });
    }
  });
});
