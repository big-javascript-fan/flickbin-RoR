$(function() {
  filter = {};
  newUrl = '';

  searchFieldHandler();
  alphabetHandler();
  infiniteScrollForTags();

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

    $('#search_query').on('keyup', function() {
      filter.query = $(this).val();
      if(filter.query.length == 0) delete filter.query;

      newUrlBuilder();

      $.get({
        url: newUrl,
        dataType: 'script'
      }).then(function(response) {
        infiniteScrollForTags();
      });
    });
  }

  function alphabetHandler() {
    $('a.alphabet').on('click', function(e) {
      filter.first_char = $(this).text();
      newUrlBuilder();
      infiniteScrollForTags();
    });
  }

  function newUrlBuilder() {
    newUrl = `${window.location.origin}/tags`;

    if(!$.isEmptyObject(filter)) {
      var firstParametr = true;

      $.each(filter, function(key, value) {
        if(firstParametr) {
          newUrl += `?${key}=${value}`;
          firstParametr = false;
        } else {
          newUrl += `&${key}=${value}`;
        }
      });
    }

    window.history.pushState({path: newUrl}, '', newUrl);
  }

  function infiniteScrollForTags() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 1;
    var groupedTagsUrl = `/api/v1/grouped_tags${window.location.search}`;

    $('.contentPanel.allTags').scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.tags-feed').height() - $(this).scrollTop()) < $(window).height() - 100;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfTags();
      }

      function loadNextBatchOfTags() {
        $.get(groupedTagsUrl, { page: nextPageNumber + 1 }).then(function(response) {
          var videosContent = '';

          if(response.length > 0) {
            $.each(response, function(index, video) {
              videosContent += `
              `
            });

            $('ul.tags-feed').append(videosContent);
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
