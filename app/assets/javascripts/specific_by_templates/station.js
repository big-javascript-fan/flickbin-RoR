$(function() {
  removeIconHandler();
  infiniteScrollForVideos();
  avatarHandler();

  $('#user_channel_description').on('keyup', function(e) {
    var maxDescriptionLentgh = 160;
    var descriptionLentgh = $(this).val().length;
    if(descriptionLentgh <= maxDescriptionLentgh) {
      $('.rightNumber').text(maxDescriptionLentgh - descriptionLentgh);
    }
  });

  function removeIconHandler() {
    $(document).on('click', 'a.removeIcon', function(e) {
      e.preventDefault();
      var parentDiv = $(this).closest('.removerBar');

      if(parentDiv.hasClass('removerBarActivated')) {
        parentDiv.removeClass('removerBarActivated');
      } else {
        parentDiv.addClass('removerBarActivated');
      }
    });

    $(document).on('click', 'a.rejectDestroyVideo', function(e) {
      e.preventDefault();
      $(this).closest( "div.removerBar").removeClass('removerBarActivated');
    });
  }

  function infiniteScrollForVideos() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 2;
    var channelSlug = $('ul.stationList').attr('channel_slug');

    $(window).scroll(function(e) {
      var scrollReachedEndOfDocument = ($('body').height() - $(this).scrollTop()) < $(this).height() + 80;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfVideos();
      }

      function loadNextBatchOfVideos() {
        $.get(`/api/v1/users/${channelSlug}`, { page: nextPageNumber }).then(function(response) {
          var sidbarTags = response.sidebar_tags;
          var stationVideos = response.station_videos;
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

          if(stationVideos.length > 0) {
            $.each(stationVideos, function(index, video) {
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
                      ${video.post_time} in
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
          }

          if(sidbarTags.length == 0 && stationVideos.length == 0) {
            lastPageReached = true;
          }

          loading = false;
          nextPageNumber += 1;
        });
      }
    });
  }

  function avatarHandler() {
    $('#user_avatar').on('change', function() {
      var preview = $('img.avatar')[0];
      var file    = this.files[0];
      var reader  = new FileReader();
      var formData = new FormData();
      formData.append('user[avatar]', $('#user_avatar')[0].files[0])

      if(file) {
        $.ajax({
          url: '/api/v1/users/avatars',
          type: 'PUT',
          data: formData,
          dataType: 'json',
          contentType: false,
          processData: false
        });

        reader.onloadend = function () {
          preview.src = reader.result;
        }
        reader.readAsDataURL(file);
      }
    })
  }
});
