$(function() {
  tagSlug = $('.titleSpecific').attr('slug');
  sortBy = '';

  sortingHandler();
  infiniteScrollForVideos();

  function sortingHandler() {
    sortBy = window.location.search.split('sort_by=').pop() || 'top_charts';
    $(`a.filter[filter=${sortBy}]`).addClass('current');

    $('.filter').on('click', function() {
      sortBy = $(this).attr('filter');
      $('.filter').removeClass('current');
      $(this).addClass('current');

      var newUrl = `${window.location.origin}/tags/${tagSlug}?sort_by=${sortBy}`;
      window.history.pushState({path: newUrl}, '', newUrl);

      infiniteScrollForVideos();
    });
  }

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 1;

    $('.contentPanel').scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.video-feed').height() - $(this).scrollTop()) < $(window).height() - 80;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get(`/api/v1/tags/${tagSlug}`, {
          page: nextPageNumber + 1,
          sort_by: sortBy
        }).then(function(response) {
          var videosContent = '';

          if($.isEmptyObject(response)) {
            lastPageReached = true;
          } else {
            $.each(response, function(index, video) {
              videosContent += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnail large" href="/videos/${video.slug}">
                      <img alt="${video.title}" class="thumbnail large" src="${video.cover_url}">
                      <span class="playerIcon"><i class="fas fa-play"></i></span>
                    </a>
                  </div>
              `
              if(sortBy == 'newest') {
                videosContent += `
                  <div class="entityCell serialText">&nbsp;</div>
                  <div class="entityCell">
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
            loading = false;
            nextPageNumber += 1;
          }
        });
      }
    });
  }
});
