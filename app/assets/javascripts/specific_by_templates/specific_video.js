$(function() {
  channelSlug = $('.upDownOptions').attr('channelSlug');
  videoSlug = $('.videoTopDesc').attr('videoSlug');
  votedValue = $('.upDownOptions').attr('voted');
  currentUserAvatarUrl = $('img.avatarHolder ').attr('src');

  votesHandler();
  commentFieldHandler();
  replyCommentHandler();

  $('.jq-dropdown-anchor-right').addClass('reverseTheme');

  function votesHandler() {
    $('span.counterOption').on('click', function(e) {
      var counterOptionElement = $(this);
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
          counterOptionElement.removeClass('voted');
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
          $('.counterOption').removeClass('voted');
          counterOptionElement.addClass('voted');
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
          counterOptionElement.addClass('voted');
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
      $(this).attr("placeholder", 'Enter comment')
    });

    $('#message').keypress(function(e) {
      if(e.which == 13) {
        var commentContent = '';

        $.post(`/api/v1/${videoSlug}/comments`, {
          message: $(this).val()
        }).then(function(response) {
          var commentatorAvatar = response.commentator.avatar || '/images/avatar_holder.jpg';

          commentContent += `
            <div class="commentEntity" comment_id="${response.id}">
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

          replyCommentHandler();
        });
      }
    });
  }

  function replyCommentHandler() {
    $('a.replyComment').on('click', function(e) {
      e.preventDefault();

      if($(this).attr('loginRequired')) {
        window.location = '/users/sign_in'
      } else {
        var parentDiv = $(this).parent();
        var commentId = $(this).closest('.commentEntity').attr('comment_id');
        var replyLink = $(this);

        $('.nestedCommentField').closest('.nestedComment').remove();
        $('a.replyComment').removeClass('hidden');

        replyLink.addClass('hidden');
        parentDiv.append(`
          <div class="nestedComment">
            <a href="#" class="commentorThumb asCommentor commentTypin">
              <img src="${currentUserAvatarUrl}" alt="User Name"/>
            </a>
            <div class="labelFields noBottomMargin">
              <input type="text" class="block noInsideLabel asCommentField nestedCommentField" placeholder="Enter comment"/>
              <button class="commentSendIcon"><i class="fas fa-paper-plane"></i></button>
            </div>
          </div>
        `)

        $('.nestedCommentField').focus();
        $('.nestedCommentField').on('focusout', function() {
          if($('.replyComment:hover').length) return;

          $(this).closest('.nestedComment').remove();
          replyLink.removeClass('hidden');
        });

        $('.nestedCommentField').keypress(function(e) {
          if(e.which == 13) sendReplyComment(commentId, $(this).val());
        });

        $('.commentSendIcon').on('click', function(e) {
          var message = $(this).closest('.nestedCommentField').val();
          sendReplyComment(commentId, message);
        });
      }
    });
  }

  function sendReplyComment(commentId, message) {
    var parentComment = $(`.commentEntity[comment_id="${commentId}"]`);
    var commentContent = '';

    $.post(`/api/v1/${videoSlug}/comments`, {
      message: message,
      parent_id: commentId
    }).then(function(response) {
      var commentatorAvatar = response.commentator.avatar || '/images/avatar_holder.jpg';
      parentComment.addClass('hasNestedComment');

      commentContent += `
        <div class="commentEntity" comment_id="${response.id}">
          <div class="nestedComment nestedCommented">
            <a href="#" class="commentorThumb">
              <img src="${commentatorAvatar}">
            </a>
            <div class="commentorLine clearfix">
              <a href="/stations/${response.commentator.channel_name}">${response.commentator.channel_name}</a>
              <span>•</span>
              <small>${response.post_time} ago</small>
            </div>
            <p>${response.message}</p>
          </div>
        </div>
      `

      $('.nestedCommentField').closest('.nestedComment').remove();
      $('a.replyComment').removeClass('hidden');
      parentComment.after(commentContent);
    });
  }
});
