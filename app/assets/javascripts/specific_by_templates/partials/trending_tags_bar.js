$(function() {
  infiniteScrollForTags();

  function infiniteScrollForTags() {
    var loading = false;
    var lastPageNumber = 1;

    $('.leftPanel').scroll(function(e) {
      var scrollReachedEndOfDocument = ($('.tag-feed').height() - $(this).scrollTop()) < $(window).height() - 200;

      if(loading) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfTags();
      }
    });

    function loadNextBatchOfTags() {
      $.get('/api/v1/home/tags', { page: lastPageNumber + 1}).then(function(response) {
        var tagContent = '';

        if(response.length > 0) {
          $.each(response, function(index, tag) {
            tagContent += `
              <li>
                <a href="/tags/${tag.slug}">${tag.title}</a>
              </li>
            `
          });

          $('ul.leftPanelTags').append(tagContent)
        }

        loading = false;
        lastPageNumber += 1;
      })
    }
  }
});
