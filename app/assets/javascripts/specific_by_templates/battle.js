twitterWinget();

function twitterWinget() {
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
}

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
    timerID = setInterval(function () {
      if ($('.uk-countdown-days').text() == 0 &&
          $('.uk-countdown-hours').text() == 0 &&
          $('.uk-countdown-minutes').text() == 0) displayWinner();
    }, 1000);
  }

  

    function displayWinner() {
      var battleId = $(".section-fight").data('battle');
      $.get(`/api/v1/battles/${battleId}`).then(function(response) {
        $($('.card-vote')[0]).html(response.first_member_voices)
        $($('.card-vote')[1]).html(response.second_member_voices)
        if (response.first_member_voices > response.second_member_voices) {
          $($('.card-fight')[0]).addClass('card-fight-winner')
        } else {
          $($('.card-fight')[1]).addClass('card-fight-winner')
        };
        $('.card-vote').addClass('card-vote-disabled');
        $('.card-vote .icon-arrow_drop_up').hide();
        $('.card-vote-description').hide();
        $('.divider-button, .divider-button-mobile').removeClass('hidden'); 
        clearInterval(timerID, 1000)
      });
   }
  
  $(".card-vote").click(function(e) {
      e.preventDefault()

      var self = this;
      var member = $(this).data('member');
      var battleId = $(".section-fight").data('battle');
      var upvote = parseInt($(self).text());
      if (member == '1') {
          $.ajax({
              type: 'PUT',
              url:  `/api/v1/battles/${battleId}`,
              data: { value1: true },
              error: function(xhr, message) {
                  console.log(xhr.status);
                  console.log(message);
              }
          }).then( function() {
              $(self).text(upvote + 1)
              $('.card-fight .icon-arrow_drop_up').remove();
          });

      } else if (member == '2') {
          $.ajax({
              type: 'PUT',
              url: `/api/v1/battles/${battleId}`,
              data: { value2: true },
              error: function(xhr, message) {
                  console.log(xhr.status);
                  console.log(xhr.statusText + error);
                  console.log(message);
              }
          }).then( function() {
              $(self).text(upvote + 1);
              $('.card-fight .icon-arrow_drop_up').remove();
          });
      } else {
          alert("no");
      };
  });

  $(".divider-button, .divider-button-mobile").click(function(e) {
      e.preventDefault()

      var battleId = $(".section-fight").data('battle');
      $.ajax({
        type: 'POST',
        url:  `/api/v1/battles/${battleId}/rematch_requests`,
        error: function(xhr, message) {
          console.log(xhr.status);
          console.log(message);
        }
      }).then( function() {
        $(".divider-button, .divider-button-mobile").addClass('divider-button-disabled');
        $(".divider-button, .divider-button-mobile").text("Rematch Requested")
      });
  });
});
