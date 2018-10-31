$(function() {
  channelSlug = $('.upDownOptions').attr('channelSlug');
  videoSlug = $('.videoTopDesc').attr('videoSlug');
  votedValue = $('.upDownOptions').attr('voted');
  currentUserId = $('.commentSection').attr('current_user_id');
  currentUserAvatarUrl = $('img.avatarHolder ').attr('src');

  votesHandler();
  commentFieldHandler();
  replyCommentHandler();
  infiniteScrollForComments();

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
          $('.counterValueHolder').text(response.new_votes_amount_for_video);
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
          $('.counterValueHolder').text(response.new_votes_amount_for_video);
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
          $('.counterValueHolder').text(response.new_votes_amount_for_video);
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

        if($(this).attr('loginRequired')) {
          window.location = '/users/sign_in'
        } else {
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
              </div>
            `

            $('.comments-feed').prepend(commentContent);
            $('#message').val('');
          });
        }
      }
    });
  }

  function replyCommentHandler() {
    $(document).on('click', 'a.replyComment', function(e) {
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
          if($('.replyComment:hover').length || $('.commentSendIcon:hover').length) return;

          $(this).closest('.nestedComment').remove();
          replyLink.removeClass('hidden');
        });

        $('.nestedCommentField').keypress(function(e) {
          if(e.which == 13) sendReplyComment(commentId, $(this).val());
        });

        $('.commentSendIcon').on('click', function(e) {
          var message = $(this).siblings('.nestedCommentField').val();
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

  function infiniteScrollForComments() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 2;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 80;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfComments();
      }

      function loadNextBatchOfComments() {
        $.get(`/api/v1/${videoSlug}/comments`, { page: nextPageNumber }).then(function(response) {
          var sidbarTags = response.sidebar_tags;
          var commentsTree = response.comments_tree;
          var sidbarTagsContent = '';

          if(sidbarTags.length > 0) {
            $.each(sidbarTags, function(index, tag) {
              sidbarTagsContent += `
                <li>
                  <a href="/tags/${tag.slug}">${tag.title}</a>
                </li>
              `
            });

            $('ul.leftPanelTags').append(sidbarTagsContent)
          }

          if(commentsTree.length < 0) {
            $.each(commentsTree, function(index, root_comment) {
              var commentContent = '';
              var commentatorAvatar = root_comment.commentator.avatar || '/images/avatar_holder.jpg';
              var rootCommentClass = 'commentEntity';

              if(root_comment.child_comments.length > 0) rootCommentClass += ' hasNestedComment';

              commentContent += `
                <div class="${rootCommentClass}" comment_id="${root_comment.id}">
                  <a href="#" class="commentorThumb">
                    <img src="${commentatorAvatar}">
                  </a>
                  <div class="commentorLine clearfix">
                    <a href="/stations/${root_comment.commentator.channel_name}">
                      ${root_comment.commentator.channel_name}
                    </a>
                    <span>•</span>
                    <small>${root_comment.post_time} ago</small>
                  </div>
                  <p>${root_comment.message}</p>
              `

              if(currentUserId && currentUserId != root_comment.commentator.id) {
                commentContent += `
                    <div class="commentReplyOption">
                      <a href="#" class="replyComment">Reply</a>
                    </div>
                  </div>
                `
              } else {
                commentContent += '</div>'
              }

              if(root_comment.child_comments.length > 0) {
                $.each(root_comment.child_comments, function(index, child_comment) {
                  var commentatorAvatar = child_comment.commentator.avatar || '/images/avatar_holder.jpg';

                  commentContent += `
                    <div class="commentEntity" comment_id="${child_comment.id}">
                      <div class="nestedComment nestedCommented">
                        <a href="#" class="commentorThumb">
                          <img src="${commentatorAvatar}">
                        </a>
                        <div class="commentorLine clearfix">
                          <a href="/stations/${child_comment.commentator.channel_name}">${child_comment.commentator.channel_name}</a>
                          <span>•</span>
                          <small>${child_comment.post_time} ago</small>
                        </div>
                        <p>${child_comment.message}</p>
                      </div>
                    </div>
                  `
                });
              }

              $('.comments-feed').append(commentContent);
            });
          }

          if(sidbarTags.length == 0 && response.comments_tree.length == 0) {
            lastPageReached = true;
          }

          loading = false;
          nextPageNumber += 1;
        });
      }
    });
  }
});
