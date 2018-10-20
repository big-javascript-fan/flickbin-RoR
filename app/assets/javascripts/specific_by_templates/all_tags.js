$(function() {
  var filter = {};

  searchFieldHandler();
  alphabetHandler();
  // infiniteScrollForTags();

  function searchFieldHandler() {
    $('a.searchIcon').on('click', function(e) {
      e.preventDefault();
      var parentDiv = $(this).closest( "div.searchOuter");

      if(parentDiv.hasClass('searchActivated')) {
        parentDiv.removeClass('searchActivated');
      } else {
        parentDiv.addClass('searchActivated');
      }
    });
  }

  function alphabetHandler() {
    $('a.alphabet').on('click', function(e) {
      filter.first_char = $(this).text();
      var newUrl = `${window.location.origin}/tags?first_char=${$(this).text()}`;
      window.history.pushState({path: newUrl}, '', newUrl);
    });
  }

  function infiniteScrollForTags() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 1;
    var filter = $('a.filter.current').text();

    $('.contentPanel.allTags').scroll(function(e) {
      // var scrollReachedEndOfDocument = ($('.tags-feed').height() - $(this).scrollTop()) < $(window).height() - 80;
var scrollReachedEndOfDocument  = true
      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfTags();
      }

      function loadNextBatchOfTags() {
        $.get('/api/v1/grouped_tags', {
          page: nextPageNumber + 1,
          first_char: filter,
          query: query
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
            nextPageNumber += 1;
          } else {
            lastPageReached = true;
          }
        });
      }
    });
  }
});
