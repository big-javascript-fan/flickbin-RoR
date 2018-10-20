$(function() {
  infiniteScrollForVideos();

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 1;
    var top1TagId = $('.top_1_tag').attr('id');
    var top2TagId = $('.top_2_tag').attr('id');

    $('.contentPanel').scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.video-feed').height() - $(this).scrollTop()) < $(window).height() - 80;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get('/api/v1/home/videos', {
          page: nextPageNumber + 1,
          top_1_tag_id: top1TagId,
          top_2_tag_id: top2TagId
        }).then(function(response) {
          var videosTop1Tag = response.videos_top_1_tag;
          var videosTop2Tag = response.videos_top_2_tag;
          var top1Content = '';
          var top2Content = '';

          if(videosTop1Tag.length > 0) {
            $.each(videosTop1Tag, function(index, video) {
              top1Content += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnail" href="/videos/${video.slug}">
                      <img alt="${video.title}" class="thumbnail" src="${video.cover_url}">
                      <span class="playerIcon"><i class="fas fa-play"></i></span>
                    </a>
                  </div>
                  <div class="entityCell serialText">${video.rank}</div>
                  <div class="entityCell">
                    <a class="descText" href=href="/videos/${video.slug}">${video.title}"</a>
                  </div>
                </li>
              `
            });

            $('.top_1_tag ul').append(top1Content)
          }

          if(videosTop2Tag.length > 0) {
            $.each(videosTop1Tag, function(index, video) {
              top2Content += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnail" href="/videos/${video.slug}">
                      <img alt="${video.title}" class="thumbnail" src="${video.cover_url}">
                      <span class="playerIcon"><i class="fas fa-play"></i></span>
                    </a>
                  </div>
                  <div class="entityCell serialText">${video.rank}</div>
                  <div class="entityCell">
                    <a class="descText" href=href="/videos/${video.slug}">${video.title}"</a>
                  </div>
                </li>
              `
            });

            $('.top_2_tag ul').append(top2Content)
          }

          loading = false;
          nextPageNumber += 1;

          if(videosTop1Tag.length == 0 && videosTop2Tag.length == 0) {
            lastPageReached = true;
          }
        })
      }
    });
  }
});
