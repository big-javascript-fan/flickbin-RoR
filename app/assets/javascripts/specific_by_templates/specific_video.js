$(function() {
  channelSlug = $('.upDownOptions').attr('channelSlug');
  videoSlug = $('.videoTopDesc').attr('videoSlug');
  votedValue = $('.upDownOptions').attr('voted');

  votesHandler();
  commentFieldHandler();

  function votesHandler() {
    $('span.counterOption').on('click', function(e) {
      var newVoteValue = $(this).hasClass('upVote') ? 1 : -1;

      if($(this).attr('loginRequired')) {
        window.location = '/users/sign_in'
      } else if(votedValue && votedValue == newVoteValue) {
        $.ajax({
          type: 'DELETE',
          url: `/api/v1/${videoSlug}/votes`,
          data: { value: newVoteValue }
        }).done(function(response, statusText, xhr) {
          votedValue = '';
          $('.counterValueHolder').text(response.new_rank);
          $('.upDownOptions').removeAttr('voted');
        }).fail(function(response, statusText, xhr) {
          console.log(response.responseJSON.messages);
        });
      } else if(votedValue && votedValue != newVoteValue) {
        $.ajax({
          type: 'PUT',
          url: `/api/v1/${videoSlug}/votes`,
          data: { value: newVoteValue }
        }).done(function(response, statusText, xhr) {
          votedValue = newVoteValue;
          $('.counterValueHolder').text(response.new_rank);
          $('.upDownOptions').attr("voted", votedValue);
        }).fail(function(response, statusText, xhr) {
          console.log(response.responseJSON.messages);
        });
      } else {
        $.post({
          url: `/api/v1/${videoSlug}/votes`,
          data: { value: newVoteValue }
        }).done(function(response, statusText, xhr) {
          votedValue = newVoteValue;
          $('.counterValueHolder').text(response.new_rank);
          $('.upDownOptions').attr("voted", votedValue);
        }).fail(function(response, statusText, xhr) {
          console.log(response.responseJSON.messages);
        });
      }
    });
  }

  function commentFieldHandler() {
    $('#message').on('click', function() {
      $(this).removeAttr('placeholder');
    });

    $('#message').on('focusout', function() {
      $(this).attr("placeholder", 'Enter your comment')
    });

    $('#message').keypress(function (e) {
      if (e.which == 13) {
        var commentContent = '';

        $.post(`/api/v1/${videoSlug}/comments`, {
          message: $(this).val()
        }).then(function(response) {
          var commentatorAvatar = response.commentator.avatar || '/images/avatar_holder.jpg';

          commentContent += `
            <div class="commentEntity">
              <a href="#" class="commentorThumb">
                <img src="${commentatorAvatar}">
              </a>
              <div class="commentorLine clearfix">
                <a href="/stations/${response.commentator.channel_name}">${response.commentator.channel_name}</a>
                <span>•</span>
                <small>${response.post_time} ago</small>
              </div>
              <p>${response.message}</p>

              <div class="commentReplyOption">
                <a href="#" class="replyComment">Reply</a>
              </div>
            </div>
          `

          $('.comments-feed').prepend(commentContent);
          $('#message').val('');
        });
      }
    });
  }
});
