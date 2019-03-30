$(function() {
  votesHandler();

  function votesHandler() {
    $(document).on('click', '.card-tags-vote', function(e) {
      var voteBox = $(this);
      var votesAmountElement = $(this).find('votes_amount')
      var videoSlug = $(this).attr('video_slug');
      var newVoteValue = 1;

      if($(this).attr('loginRequired')) {
        window.location = '/users/sign_in'
      } else if($(this).hasClass('active')) {
        $.ajax({
          type: 'DELETE',
          url: `/api/v1/${videoSlug}/votes`,
          data: { value: newVoteValue }
        }).done(function(response, statusText, xhr) {
          voteBox.removeClass('active');
          voteBox.html(`
            <span class="icon icon-arrow_drop_up"></span>
            ${response.new_votes_amount_for_video}
          `).trigger('change');
        }).fail(function(response, statusText, xhr) {
          console.log(response.responseJSON.messages);
        });
      } else {
        $.post({
          url: `/api/v1/${videoSlug}/votes`,
          data: { value: newVoteValue }
        }).done(function(response, statusText, xhr) {
          voteBox.addClass('active');
          voteBox.html(`
            <span class="icon icon-arrow_drop_up"></span>
            ${response.new_votes_amount_for_video}
          `).trigger('change');
        }).fail(function(response, statusText, xhr) {
          console.log(response.responseJSON.messages);
        });
      }
    });
  }

  if ($('.uk-countdown-days').text() > 0 ||
      $('.uk-countdown-hours').text() > 0 ||
      $('.uk-countdown-minutes').text() > 0) {
    setInterval(function () {
      if ($('.uk-countdown-days').text() == 0 &&
          $('.uk-countdown-hours').text() == 0 &&
          $('.uk-countdown-minutes').text() == 0) location.reload();
    }, 1000);
  }
});
