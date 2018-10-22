$(function() {
  channelSlug = $('.upDownOptions').attr('channelSlug');
  videoSlug = $('.videoTopDesc').attr('videoSlug');

  votesHandler();
  commentFieldHandler();

  function votesHandler() {
    $('span.counterOption').on('click', function(e) {
      var voteValue = $(this).hasClass('upVote') ? 1 : -1

      if($(this).attr('loginRequired')) {
        window.location = '/users/sign_in'
      } else if($(this).attr('voted')){

      } else {
        $.post({
          url: `/api/v1/${videoSlug}/votes`,
          data: { value: voteValue }
        }).done(function(response, statusText, xhr) {
          $('.counterValueHolder').text(response.new_rank);
        }).fail(function(response, statusText, xhr) {
          alert(response.responseJSON.messages);
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

        $.post(`/api/v1/${videoSlug}/comments`,{
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
          $(this).val('');
        });
      }
    });
  }
});
