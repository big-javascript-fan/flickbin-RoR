$(function() {
  infiniteScrollForVideos();

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageReached = false;
    var offset = 20;
    var nextSidbarTagsPageNumber = 3;

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 800;
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
                <div class="grid-item">
                  <div class="card card-video">
                    <figure class="card-background">
                      <img src="${ video.cover_url }">
                    </figure>
                    <div class="card-overlay"></div>
                    <header class="card-header">
                      <figure class="card-image">
                        <img src="${ video.user.avatar.thumb_44x44.url }" alt="Person">
                      </figure>
                      <h5 class="card-title">
                        <a href="/stations/${ video.user.slug }" class="card-link">${ video.user.slug }</a>
                      </h5>
                    </header>
                    <div class="card-body">
                    <a href="/videos/${ video.slug }" class="card-description">${ video.title }</a>
                      <div class="card-posted-by">
                        ${video.source === 'youtube' ? '<span class="icon icon-youtube"></span>' : ''}
                        ${video.source === 'daily_motion' ? '<span class="icon icon-dailymotion"></span>' : ''}
                        ${video.source === 'twitch' ? '<span class="icon icon-twitch"></span>' : ''}
                        
                        posted in <a href="/topics/${ video.tag.slug }" class="card-link bold">${ video.tag.title }</a>
                      </div>
                    </div>
                  </div>
                </div>
              `
            });
          }

          if(videos != 0) {
            function createScrollRow () {
              $('.section-videos .grid').append(videosContent);
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
