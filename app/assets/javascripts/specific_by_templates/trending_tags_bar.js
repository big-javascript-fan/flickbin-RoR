$(function() {
  infiniteScrollForTrendingTags();

  function infiniteScrollForTrendingTags() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 2;
    var numberOfTagsPerPage = 35;

    if ($('section.home').length > 0) {
      nextPageNumber = 3;
    } else if ($('section.allTags').length > 0) {
      numberOfTagsPerPage = 70;
    } else if ($('section.specificVideo').length > 0) {
      nextPageNumber = 3;
    }

    $('.leftTagsOuter ').scroll(function(e) {
      var scrollReachedEndOfDocument;

      scrollReachedEndOfDocument = ($('.tag-feed').height() - $(this).scrollTop()) < $(window).height();

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfTags();
      }
    });

    function loadNextBatchOfTags() {
      $.get('/api/v1/topics', {
        page: nextPageNumber,
        number_of_tags_per_page: numberOfTagsPerPage
      }).then(function(response) {
        var tagContent = '';

        if(response.length > 0) {
          $.each(response, function(index, tag) {
            tagContent += `
              <li>
                <a href="/topics/${tag.slug}">${tag.title}</a>
              </li>
            `
          });

          $('ul.leftPanelTags').append(tagContent)
        } else {
          lastPageReached = true;
        }

        loading = false;
        nextPageNumber += 1;
      })
    }
  }
});
