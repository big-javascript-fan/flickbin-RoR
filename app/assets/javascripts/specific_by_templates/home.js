$(function() {
  infiniteScrollForVideos();

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageReached = false;
    var offset = 4;
    var nextSidbarTagsPageNumber = 3;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 80;

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
          var leftTag = response.left_tag;
          var rightTag = response.right_tag;
          var sidbarTagsContent = '';
          var leftTagContent = '';
          var rightTagContent = '';

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

          if(leftTag.top_10_videos.length > 0) {
            leftTagContent += `
              <div id="${leftTag.id}" class="colHalf colTitle clearfix mobileColBottom left_tag top-margin-25">
                <div class="clearfix bottom-margin-15">
                <span class="sideTitle">${leftTag.title}</span>
                <a class="seeAllLink" href="/tags/${leftTag.slug}">SEE ALL</a>
              </div>

              <ul class="entityList">
            `

            $.each(leftTag.top_10_videos, function(index, video) {
              leftTagContent += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnailLink" href="/videos/${video.slug}">
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

            leftTagContent += `
                </ul>
              </div>
            `

            $('.video-feed').append(leftTagContent)
          }

          if(rightTag.top_10_videos.length > 0) {
            rightTagContent += `
              <div id="${rightTag.id}" class="colHalf clearfix right_tag top-margin-25">
                <div class="clearfix bottom-margin-15">
                <span class="sideTitle">${rightTag.title}</span>
                <a class="seeAllLink" href="/tags/${rightTag.slug}">SEE ALL</a>
              </div>

              <ul class="entityList">
            `

            $.each(rightTag.top_10_videos, function(index, video) {
              rightTagContent += `
                <li class="entityRow">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnailLink" href="/videos/${video.slug}">
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

            rightTagContent += `
                </ul>
              </div>
            `

            $('.video-feed').append(rightTagContent)
          }

          loading = false;
          nextSidbarTagsPageNumber += 1;
          offset += 4;

          if(leftTag.top_10_videos.length == 0 && rightTag.top_10_videos.length == 0 && sidbarTags.length == 0) {
            lastPageReached = true;
          }
        })
      }
    });
  }
});
