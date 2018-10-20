$(function() {
  infiniteScrollForTags();

  function infiniteScrollForTags() {
    var loading = false;
    var nextPageNumber = 1;

    $('.leftPanel, .leftTagsOuter').scroll(function(e) {
      var scrollReachedEndOfDocument;

      if($(this).hasClass('leftPanel')) {
        scrollReachedEndOfDocument = ($('.tag-feed').height() - $(this).scrollTop()) < $(window).height() - 200;
      } else if($(this).hasClass('leftTagsOuter')) {
        scrollReachedEndOfDocument = ($('.tag-feed').height() - $(this).scrollTop()) < $(window).height() - 50;
      }

      if(loading) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfTags();
      }
    });

    function loadNextBatchOfTags() {
      $.get('/api/v1/home/tags', { page: nextPageNumber + 1}).then(function(response) {
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
        nextPageNumber += 1;
      })
    }
  }
});
