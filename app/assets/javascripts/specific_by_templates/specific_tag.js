$(function() {
  infiniteScrollForVideos();

  $('.filter').on('click', function() {
    $('.filter').removeClass('current');
    $(this).addClass('current');
  });

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageNumber = 1;
    var tagSlug = $('.titleSpecific').attr('slug');
    var filter = $('a.filter.current').text();

    $('.contentPanel').scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.video-feed').height() - $(this).scrollTop()) < $(window).height() - 80;

      if(loading) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get(`/api/v1/tags/${tagSlug}`, {
          page: lastPageNumber + 1,
          sort_by: filter
        }).then(function(response) {
          var videosContent = '';

          if(response.length > 0) {
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
              if(filter == 'newest') {
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
            lastPageNumber += 1;
          }
        });
      }
    });
  }
});
