$(function() {
  infiniteScrollForVideos();

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageReached = false;
    var offset = 20;
    var nextSidbarTagsPageNumber = 3;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 1300;
      console.log(scrollReachedEndOfDocument);
      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get('/api/v1/home', {
          page: nextSidbarTagsPageNumber,
          offset: offset
        }).then(function(response) {
          var sidbarTags = response.sidebar_tags;
          var videos = response.videos;
          var sidbarTagsContent = '';
          var videosContent = '';

          if(sidbarTags.length > 0) {
            $.each(sidbarTags, function(index, tag) {
              sidbarTagsContent += `
                <li>
                  <a href="/topics/${tag.slug}">${tag.title}</a>
                </li>
              `
            });

            $('ul.leftPanelTags').append(sidbarTagsContent)
          }

          if(videos.length > 0) {
            $.each(videos, function(index, video) {
              videosContent += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnailLink" href="/videos/${video.slug}">
                      <img alt="${video.title}" class="thumbnail" src="${video.cover_url}">
                      <span class="playerIcon displayNone"><i class="fas fa-play"></i></span>
                    </a>
                  </div>
                  <div class="entityCell serialText">${video.rank}</div>
                  <div class="entityCell">
                    <a class="descText homeTitle" href="/videos/${video.slug}">${video.title}</a>
                  </div>
                </li>
              `
            });

          }

          if(videos != 0) {
            function createScrollRow () {
              $('body').append(videosContent);
            }
            createScrollRow();
          }

          loading = false;
          nextSidbarTagsPageNumber += 1;
          offset += 10;
          if(videos.length == 0  && sidbarTags.length == 0) {
            lastPageReached = true;
          }
        })
      }
    });
  }
});
