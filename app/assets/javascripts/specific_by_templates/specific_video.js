$(function() {
  channelSlug = $('.upDownOptions').attr('channelSlug');
  videoSlug = $('.videoTopDesc').attr('videoSlug');
  votedValue = $('.upDownOptions').attr('voted');
  currentUserId = $('.commentSection').attr('current_user_id');
  currentUserAvatarUrl = $('img.avatarHolder ').attr('src');

  votesHandler();
  votesCountHandler();
  commentFieldHandler();
  replyCommentHandler();
  infiniteScrollForComments();
  onboardCloseClick();
  textareaAutoheight();


  function textareaAutoheight(){
    $('.autoresize').on('input keyup', function() {
      var paddingTop = $(this).css('padding-top').replace('px', ''),
          paddingBottom = $(this).css('padding-bottom').replace('px', '');

      $(this).css('height', '68px');
      $(this).css('height', (this.scrollHeight) + 'px');
    });
  }

  if(window.location.hash == '#message') {
    window.scrollDownAnimation();
  } else if(window.location.hash == '#voting_button') {
    votingBttonHighlight();
  }

  $(document).ready(function () {
    videoPageInfoWidth();
    centerVidOnboardContent();
    vidOnboardHandler();
    $(window).resize(function() {
      videoPageInfoWidth();
      centerVidOnboardContent();
    });
  });

  function votingBttonHighlight() {
    var buttonForHighlighting = $(window.location.hash);

    if(buttonForHighlighting.length > 0 && window.location.hash == '#voting_button' ) {
      buttonForHighlighting.addClass('highlight');
      setTimeout(function(){
        buttonForHighlighting.removeClass('highlight');
      }, 2100)
    }
    history.replaceState(null, null, ' ');
  }

  function videoPageInfoWidth() {
    var vidTopWidth = $('.videoTop').width();
    var upVoteWidth = $('.upDownOptions').width();
    var windowSize = $(window).width();
    if(windowSize >= 768) {
     var elementsWidth = ((vidTopWidth - 70) - (upVoteWidth + 200));
     $('.videoTopDesc').css('width', elementsWidth);
    } else if(windowSize <= 768) {
      var elementsWidth = ((vidTopWidth - 65) - (upVoteWidth));
      $('.videoTopDesc').css('width', elementsWidth);
    }
  }
  function centerVidOnboardContent() {
    var containerHeight = $('.vidOnboardContent').height();
    var avatarHeight = $('.vidOnboardFlickbear').height();
    var margin = (containerHeight - avatarHeight)/2;
    $('.vidOnboardFlickbear').css({'margin-top': margin, 'margin-bottom': margin});
  }
  function onboardCloseClick() {
    $('.closeOnboardLink').click(function() {
      localStorage.setItem('vidPageLoadCount', 3);
      vidOnboardHandler();
    });
  }
  function vidOnboardHandler() {
    var loadCount = 1;
    if (localStorage.getItem ('vidPageLoadCount') === null) {
      parseInt(localStorage.setItem('vidPageLoadCount', loadCount));
      $('.videoOnboarding').removeClass('displayNone');
      centerVidOnboardContent();
    } else {
      localStorage.setItem('vidPageLoadCount', parseInt(localStorage.getItem('vidPageLoadCount')) +1);
      var localStorageValue = localStorage.getItem('vidPageLoadCount');
      if (localStorageValue >= 4) {
        $('.vidOnboardContent').addClass('animated fadeOut');
        function hideVidOnboardContainer() {
          $('.videoOnboarding').css({'display': 'none'})
          $('.videoTop').css({'margin-top': '-40px'});
        }
        setInterval(hideVidOnboardContainer, 700);
      } else {
        $('.videoOnboarding').removeClass('displayNone');
        centerVidOnboardContent();
      }
    }
  };

  $('.jq-dropdown-anchor-right').addClass('reverseTheme');

  function votesHandler() {
    $('.counter-wrapper').on('click', function(e) {
      var counterOptionElement = $(this);
      var newVoteValue = $(".counterOption").hasClass('upVote') ? 1 : -1;

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
          $('.counterValueHolder').text(response.new_votes_amount_for_video).trigger('change');
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
          $('.counterValueHolder').text(response.new_votes_amount_for_video).trigger('change');
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
          $('.counterValueHolder').text(response.new_votes_amount_for_video).trigger('change');
          $('.upDownOptions').attr("voted", votedValue);
        }).fail(function(response, statusText, xhr) {
          console.log(response.responseJSON.messages);
        });
      }
    });
  }

  function votesCountHandler() {
    $('.counterNumber').on('change',function(e) {
      var countNumber = parseInt($(this).text());
      if(countNumber <= 0) {
        $('.downVote').addClass('inactiveDownVote');
      } else {
        $('.downVote').removeClass('inactiveDownVote');
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
      if(e.which == 13){
        e.preventDefault();
        if($( window ).width() > 940){
          sendMessange(this, e)
        }
      }
    });
    $('#message-button').on('click', function(e){
      e.preventDefault();
      var message = $('#message');
      sendMessange(message, e);
    });

    function sendMessange(elem, event) {
      var commentContent = '';

      if($(elem).attr('loginRequired')) {
        window.location = '/users/sign_in'
      } else if(!!$(elem).val()) {
        $.post(`/api/v1/${videoSlug}/comments`, {
          message: $(elem).val()
        }).then(function(response) {
          var commentatorAvatar = response.commentator.avatar || '/images/avatar_holder.jpg';

          commentContent += `
              <div class="commentEntity" comment_id="${response.id}">
                <a href="#" class="commentorThumb">
                  <img src="${commentatorAvatar}">
                </a>
                <div class="commentorLine clearfix">
                  <a href="/stations/${response.commentator.channel_slug}">${response.commentator.channel_name}</a>
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
          $('.blankComments').remove();
        });
      } else{
        console.log('false');
      }
    }
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
              <a href="/stations/${response.commentator.channel_slug}">${response.commentator.channel_name}</a>
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
    var lastPageForSideBarReached = false;
    var lastPageForBodyReached = false;
    var nextPageNumber = 3;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.comments-feed').height() - $(this).scrollTop()) < $(this).height() + 80;

      if(loading || lastPageForBodyReached) {
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
                  <a href="/topics/${tag.slug}">${tag.title}</a>
                </li>
              `
            });

            $('ul.leftPanelTags').append(sidbarTagsContent)
          } else {
            lastPageForSideBarReached = true;
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
                    <a href="/stations/${root_comment.commentator.channel_slug}">
                      ${root_comment.commentator.channel_name}
                    </a>
                    <span>•</span>
                    <small>${root_comment.post_time} ago</small>
                  </div>
                  <p>${root_comment.message}</p>
                  <div class="commentReplyOption">
                    <a href="#" class="replyComment">Reply</a>
                  </div>
                </div>
              `

              // if(currentUserId && currentUserId != root_comment.commentator.id) {
              //   commentContent += `
              //       <div class="commentReplyOption">
              //         <a href="#" class="replyComment">Reply</a>
              //       </div>
              //     </div>
              //   `
              // } else {
              //   commentContent += '</div>'
              // }

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
                          <a href="/stations/${child_comment.commentator.channel_slug}">${child_comment.commentator.channel_name}</a>
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
          } else {
            lastPageForBodyReached = true;
          }

          loading = false;
          nextPageNumber += 1;
        });
      }
    });
  }
});
