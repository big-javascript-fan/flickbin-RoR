$(function() {
  realTimeVideo ();

  function realTimeVideo () {
    var scrollState = false;
    var newVideos = [];

    infiniteScrollForVideos();
    createNewVideo();

    function setVideoToPage (state) {

      var videoButton = $('.newVideoBtn');

      if (state && newVideos.length > 0) {
        videoButton.fadeIn();
        videoButton.text('New videos ' + newVideos.length);
      } else {
        videoButton.fadeOut();
        newVideos.forEach(function(item) {
          $('.grid-video').prepend(item);
          newVideos = [];
        });
      }

    }
    UIkit.util.on('#js-scroll-trigger', 'scrolled', function () {
      newVideos.forEach(function(video){
        $('.grid-video').prepend(video);
        newVideos = [];
      });
    });
    function createNewVideo() {
      App.messages = App.cable.subscriptions.create('HomePageChannel', {
        received: function(data) {
          console.log(data);
          if (data.action === 'create') {
            var videosContent = `
            <div id="${data.video.id}" class="grid-item new-grid-item animation-fade animation-slow">
              <div class="card card-video">
                <figure class="card-background">
                  <img src="${data.video.cover.url}">
                </figure>
                <a href="/videos/${data.video.slug}" class="card-overlay"></a>
                <div class="card-foreground">
                  <a href="/stations/${data.user.slug}" class="card-header">
                    <figure class="card-image">
                      <img src=" ${data.user.avatar.thumb_44x44.url ? data.user.avatar.thumb_44x44.url : '/images/avatar_holder.jpg'} " alt="Person">
                    </figure>
                    <h5 class="card-title">
                      ${data.user.slug}
                    </h5>
                  </a>
                  <div class="card-body">
                    <a href="/videos/${data.video.slug}" class="card-description">${data.video.title}</a>
                    <div class="card-posted-by">
                      ${data.video.source === 'youtube' ? '<span class="icon icon-youtube"></span>' : ''}
                      ${data.video.source === 'daily_motion' ? '<span class="icon icon-dailymotion"></span>' : ''}
                      ${data.video.source === 'twitch' ? '<span class="icon icon-twitch"></span>' : ''}

                      posted in <a href="/topics/${data.tag.slug}" class="card-link bold">${data.tag.title}</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          `;
            newVideos.push(videosContent);
            console.log(newVideos);
            setVideoToPage (scrollState);
          } else if (data.action === 'destroy'){
            newVideos.forEach(function (item,i) {
              if(item.indexOf(`id="${data.video.id}"`) !== -1 ) {
                newVideos.splice(newVideos.indexOf(i), 1);
              };
            });
            setVideoToPage (scrollState);
            $(`.grid-video .grid-item#${data.video.id}`).remove();
          }
        }
      });
    }

    function infiniteScrollForVideos() {
      var loading = false;
      var lastPageReached = false;
      var offset = 20;
      var nextSidbarTagsPageNumber = 3;


      $(window).scroll(function (e) {
        var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 1200;

        if($(this).scrollTop() <= $('.section-videos').offset().top){
          scrollState = false;
          setVideoToPage (scrollState);
        } else {
          scrollState = true;
          if( newVideos.length < 0) {
            setVideoToPage (scrollState);
          }
        }

        if (loading || lastPageReached) {
          return false;
        } else if (scrollReachedEndOfDocument) {
          loading = true;
          scrollState = true;
          loadNextBatchOfVideos();
        }

        function loadNextBatchOfVideos() {
          $.get('/api/v1/home', {
            page: nextSidbarTagsPageNumber,
            offset: offset
          }).then(function (response) {
            var sidbarTags = response.sidebar_tags;
            var videos = response.videos;
            var sidbarTagsContent = '';
            var videosContent = '';

            if (sidbarTags.length > 0) {
              $.each(sidbarTags, function (index, tag) {
                sidbarTagsContent += `
                <li>
                  <a href="/topics/${tag.slug}">${tag.title}</a>
                </li>
              `
              });

              $('ul.leftPanelTags').append(sidbarTagsContent)
            }

            if (videos.length > 0) {
              $.each(videos, function (index, video) {
                videosContent += `
                <div id="${video.id}" class="grid-item">
                  <div class="card card-video">
                    <figure class="card-background">
                      <img src="${video.cover_url}">
                    </figure>
                    <a href="/videos/${video.slug}" class="card-overlay"></a>
                    <div class="card-foreground">
                      <a href="/stations/${video.user_slug}" class="card-header">
                        <figure class="card-image">
                          <img src="${video.user_avatar.thumb_44x44.url ? video.user_avatar.thumb_44x44.url : '/images/avatar_holder.jpg'}" alt="Person">
                        </figure>
                        <h5 class="card-title">
                          ${video.user_slug}
                        </h5>
                      </a>
                      <div class="card-body">
                        <a href="/videos/${video.slug}" class="card-description">${video.title}</a>
                        <div class="card-posted-by">
                          ${video.source === 'youtube' ? '<span class="icon icon-youtube"></span>' : ''}
                          ${video.source === 'daily_motion' ? '<span class="icon icon-dailymotion"></span>' : ''}
                          ${video.source === 'twitch' ? '<span class="icon icon-twitch"></span>' : ''}

                          posted in <a href="/topics/${video.tag_slug}" class="card-link bold">${video.tag_title}</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              `
              });
            }

            if (videos != 0) {
              function createScrollRow() {
                $('.section-videos .grid').append(videosContent);
              }
              createScrollRow();

            }


            loading = false;
            nextSidbarTagsPageNumber += 1;
            offset += 10;
            if (videos.length == 0 && sidbarTags.length == 0) {
              lastPageReached = true;
            }
          })
        }
      });
    }

    var getGridVideo = document.querySelector(".grid-video");
    animateCSSGrid.wrapGrid(getGridVideo, {
      duration: 700
    });
  }
});
