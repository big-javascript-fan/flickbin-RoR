$(function() {
  lastPageReached = false;
  nextPageNumber = 2;
  tagSlug = $('.titleSpecific').attr('slug');
  sortBy = '';
  if($('.video-feed').attr('video_ids')) {
    window.currentUserVotedVideoIds = $.parseJSON($('.video-feed').attr('video_ids'));
  } else {
    window.currentUserVotedVideoIds = [];
  }

  sortingHandler();
  infiniteScrollForVideos();
  votesHandler();

  function sortingHandler() {
    sortBy = window.location.search.split('sort_by=').pop() || 'top_charts';
    $(`a.filter[sort_by=${sortBy}]`).addClass('current');

    $('a.filter').on('click', function(e) {
      e.preventDefault();
      lastPageReached = false;
      nextPageNumber = 2;
      sortBy = $(this).attr('sort_by');
      $('.filter').removeClass('current');
      $(this).addClass('current');

      var newUrl = `${window.location.origin}/topics/${tagSlug}?sort_by=${sortBy}`;
      window.history.pushState({path: newUrl}, '', newUrl);

      $.ajax({
        dataType: 'script',
        url: newUrl,
        cache: false
      });
    });
  }
  function infiniteScrollForVideos() {
    var loading = false;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 80;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get(`/api/v1/topics/${tagSlug}`, {
          page: nextPageNumber,
          sort_by: sortBy
        }).then(function(response) {
          var sidbarTags = response.sidebar_tags;
          var tagVideos = response.tag_videos;
          var sidbarTagsContent = '';
          var videosContent = '';

          if(sidbarTags && sidbarTags.length > 0) {
            $.each(sidbarTags, function(index, tag) {
              sidbarTagsContent += `
                <li>
                  <a href="/topics/${tag.slug}">${tag.title}</a>
                </li>
              `
            });

            $('ul.leftPanelTags').append(sidbarTagsContent)
          }
          if(tagVideos && tagVideos.length > 0) {
            $.each(tagVideos, function(index, video) {
              videosContent += `
                <li class="card card-video-tags">
                  <div class="card-media">
                    <div class="tagThumbnailLink large">
                      <img alt="${video.title}" class="tagThumbnail large" src="${video.cover_url}">
                      <span class="playerIcon displayNone"><i class="fas fa-play"></i></span>
                    </div>
                    <div class="card-cover">
                        ${video.source === 'youtube' ? '<span class="icon youtube-icon"></span>' : ''}
                        ${video.source === 'facebook' ? '<span class="icon facebook-icon"></span>' : ''}
                        ${video.source === 'daily_motion' ? '<span class="icon dailymotion-icon"></span>' : ''}
                        ${video.source === 'twitch' ? '<span class="icon fab fa-twitch"></span>' : ''}
                        <a href="/videos/${video.slug}" class="descText">${video.title}</a>
                      </div>
                    </div>
                  </div>
                  <div class="card-body card-body-newest">
                `
              if(sortBy == 'newest') {
                videosContent += `
                      <span class="time">${video.post_time} ago</span>
                      <a class="descText" href="/videos/${video.slug}">
                        ${video.source === 'youtube' ? '<span class="icon youtube-icon"></span>' : ''}
                        ${video.source === 'facebook' ? '<span class="icon facebook-icon"></span>' : ''}
                        ${video.source === 'daily_motion' ? '<span class="icon dailymotion-icon"></span>' : ''}
                        ${video.source === 'twitch' ? '<span class="icon fab fa-twitch"></span>' : ''}
                        ${video.title}
                      </a>
                  `
              } else {
                videosContent += `
                      <div class="card-description">
                        <a class="descText" href="/videos/${video.slug}">${video.title}</a>
                      </div>
                      <div class="card-info">
                        <div class="card-tags">
                          <div class="card-tags-id"> #${video.rank} </div>
                          <div class="card-tags-like card-tags-vote ${ currentUserVotedVideoIds.includes(parseInt(video.id)) ? 'active' : '' }" video_slug=${video.slug}>
                            <span class="icon icon-arrow_drop_up"></span>
                            ${video.votes_amount}
                          </div>
                          <a href="/videos/${video.slug}#message" class="card-tags-comment" %>
                            <span class="icon fas fa-comment-alt"></span>
                            ${video.comments_count}
                          </a>
                          ${video.source === 'youtube' ? '<span class="icon youtube-icon"></span>' : ''}
                          ${video.source === 'facebook' ? '<span class="icon facebook-icon"></span>' : ''}
                          ${video.source === 'daily_motion' ? '<span class="icon dailymotion-icon"></span>' : ''}
                          ${video.source === 'twitch' ? '<span class="icon fab fa-twitch"></span>' : ''}
                        </div>
                        <div class="card-posted">posted by
                          <span>
                            <a href="/stations/${video.channel_slug}">${video.channel_name} (${video.user_rank})</a>
                          </span>
                        </div>
                      </div>
                  `
              }
              `
                  </div>
                </li>
                `
            });
            $('ul.video-feed').append(videosContent);
          }

          if(sidbarTags && sidbarTags.length == 0 && tagVideos && tagVideos.length == 0) {
            lastPageReached = true;
          }

          loading = false;
          nextPageNumber += 1;
        });
      }
    });
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
});
