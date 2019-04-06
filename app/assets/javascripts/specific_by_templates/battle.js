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
  sendTwitter();

  function sendTwitter() {
    $('.form-button').on('click', function (e){
      e.preventDefault();

      var location = document.location.href;
      var parent = $(this).parent();
      var textarea = parent.find('.textarea');
      var textareaContent;

      if (textarea.val() == ""){
        textareaContent = textarea.text();
      } else {
        textareaContent = textarea.val();
      }

      $(this).attr("href", "https://twitter.com/intent/tweet?url=" + location + "/&text=" + textareaContent);
    })
  }

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
    clearInterval(timerID, 1000)
    var battleId = $(".section-fight").data('battle');
    var winnerTwitterAccountName = '';
    var loserTwitterAccountName = '';
    var winnerVotes = 0;
    var loserVotes = 0;

    $.get(`/api/v1/battles/${battleId}/result`).then(function(response) {
      $('.card-vote').first().html(response.first_member_votes)
      $('.card-vote').last().html(response.second_member_votes)
      if (response.first_member_votes > response.second_member_votes) {
        $('.card-fight').first().addClass('card-fight-winner')
        winnerTwitterAccountName = $('.card-twitter').first().text().trim();
        loserTwitterAccountName = $('.card-twitter').last().text().trim();
        winnerVotes = $('.card-vote').first().text().trim();
        loserVotes = $('.card-vote').last().text().trim();
      } else if (response.second_member_votes > response.first_member_votes) {
        $('.card-fight').last().addClass('card-fight-winner')
        winnerTwitterAccountName = $('.card-twitter').last().text().trim();
        loserTwitterAccountName = $('.card-twitter').first().text().trim();
        winnerVotes = $('.card-vote').last().text().trim();
        loserVotes = $('.card-vote').first().text().trim();
      }
      if (response.first_member_votes != response.second_member_votes) {
        $('.winner-tweet').removeClass('hidden');
        $('.winner-tweet .card-image img').attr('src', $('.card-fight-winner .card-image img').attr('src'));
        $('.winner-tweet .textarea').text("Congratulations to " + winnerTwitterAccountName + " for winning the Flickbin creator battle against " + loserTwitterAccountName + ". The final vote count " + winnerVotes + " to " + loserVotes + " in favor of " + winnerTwitterAccountName + ".");
      }
      $('.card-vote').addClass('card-vote-disabled');
      $('.card-vote .icon-arrow_drop_up').hide();
      $('.card-vote-description').hide();
      $('.divider-button, .divider-button-mobile').removeClass('hidden');
      $('.fan-tweet').addClass('hidden');
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
