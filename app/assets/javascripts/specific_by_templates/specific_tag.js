$(function() {
  tagSlug = $('.titleSpecific').attr('slug');
  sortBy = '';

  sortingHandler();
  infiniteScrollForVideos();

  function sortingHandler() {
    sortBy = window.location.search.split('sort_by=').pop() || 'top_charts';
    $(`a.filter[sort_by=${sortBy}]`).addClass('current');

    $('a.filter').on('click', function(e) {
      e.preventDefault();

      sortBy = $(this).attr('sort_by');
      $('.filter').removeClass('current');
      $(this).addClass('current');

      var newUrl = `${window.location.origin}/tags/${tagSlug}?sort_by=${sortBy}`;
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
    var lastPageReached = false;
    var nextPageNumber = 2;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 80;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get(`/api/v1/tags/${tagSlug}`, {
          page: nextPageNumber,
          sort_by: sortBy
        }).then(function(response) {
          var sidbarTags = response.sidebar_tags;
          var tagVideos = response.tag_videos;
          var sidbarTagsContent = '';
          var videosContent = '';

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

          if(tagVideos.length > 0) {
            $.each(tagVideos, function(index, video) {
              videosContent += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="tagThumbnailLink large" href="/videos/${video.slug}">
                      <img alt="${video.title}" class="tagThumbnail large" src="${video.cover_url}">
                      <span class="playerIcon"><i class="fas fa-play"></i></span>
                    </a>
                  </div>
              `
              if(sortBy == 'newest') {
                videosContent += `
                  <div class="entityCell paddingLeft20">
                    <a class="descText" href="/videos/${video.slug}">
                      <span class="time">${video.post_time} in</span>
                      ${video.title}
                    </a>
                  </div>
                `
              } else {
                videosContent += `
                  <div class="entityCell serialText">${video.rank}</div>
                  <div class="entityCell">
                    <a class="descText" href="/videos/${video.slug}">${video.title}</a>
                  </div>
                </li>
                `
              }
            });

            $('ul.video-feed').append(videosContent);
          }

          if(sidbarTags.length == 0 && tagVideos.length == 0) {
            lastPageReached = true;
          }

          loading = false;
          nextPageNumber += 1;
        });
      }
    });
  }
});
