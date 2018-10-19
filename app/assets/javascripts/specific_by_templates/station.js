$(function() {
  removeIconHandler();
  infiniteScrollForVideos();

  $('#user_channel_description').on('keyup', function(e) {
    var maxDescriptionLentgh = 160;
    var descriptionLentgh = $(this).val().length;
    if(descriptionLentgh <= maxDescriptionLentgh) {
      $('.rightNumber').text(maxDescriptionLentgh - descriptionLentgh);
    }
  });

  function removeIconHandler() {
    $('a.removeIcon').on('click', function(e) {
      e.preventDefault();
      var parentDiv = $(this).closest( "div.removerBar");

      if(parentDiv.hasClass('removerBarActivated')) {
        parentDiv.removeClass('removerBarActivated');
      } else {
        parentDiv.addClass('removerBarActivated');
      }
    });

    $('a.rejectDestroyVideo').on('click', function(e) {
      e.preventDefault();
      $(this).closest( "div.removerBar").removeClass('removerBarActivated');
    });
  }

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageNumber = 1;
    var channelSlug = $('ul.stationList').attr('channel_slug');

    $('.contentPanel').scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.video-feed').height() - $(this).scrollTop()) < $(window).height() - 500;

      if(loading) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get(`/api/v1/users/${channelSlug}/videos`, { page: lastPageNumber + 1}).then(function(response) {
          var videosContent = '';

          if(response.length > 0) {
            $.each(response, function(index, video) {
              videosContent += `
                <li class="entityRow" slug="${video.slug}">
                  <div class="entityCell thumbnailCell">
                    <a class="thumbnail large" href="/videos/"${video.slug}">
                      <img alt="${video.title}" class="thumbnail large" src="${video.cover_url}">
                      <span class="playerIcon"><i class="fas fa-play"></i></span>
                    </a>
                  </div>
                  <div class="entityCell cellSpace24">&nbsp;</div>
                  <div class="entityCell hasRemover">
                    <span class="postTime">
                      about 19 hours in
                      <a href="/tags/${video.tag.slug}">${video.tag.title}</a>
                    </span>
                    <a class="descText" href="/videos/${video.slug}">${video.title}</a>
                    <div class="removerBar" id="${video.id}">
                      <span class="removerBarTrack">Are you sure?
                        <a data-remote="true" rel="nofollow" data-method="delete" href="/videos/${video.slug}">Yes</a>
                        <a href="#" class="rejectDestroyVideo">No</a>
                      </span>
                      <a href="#" class="removeIcon">×</a>
                    </div>
                  </div>
                </li>
              `
            });

            $('ul.stationList').append(videosContent);
            removeIconHandler();
          }
        });
      }
    });
  }
});
