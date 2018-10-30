$(function() {
  newUrl = '';
  filter = filterBuilder();

  searchFieldHandler();
  alphabetHandler();
  infiniteScrollForTags();

  function searchFieldHandler() {
    if($('#search_query').val().length > 0) {
      $('.searchOuter').addClass('searchActivated');
    }

    $('a.searchIcon').on('click', function(e) {
      e.preventDefault();
      var parentDiv = $(this).closest('.searchOuter');

      $('#search_query').focus();

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
      e.preventDefault();

      filter.first_char = $(this).text();
      newUrlBuilder();

      $.get({
        url: newUrl,
        dataType: 'script'
      }).then(function(response) {
        infiniteScrollForTags();
      });
    });
  }

  function newUrlBuilder() {
    newUrl = `${window.location.origin}/tags`;
    if(!$.isEmptyObject(filter)) newUrl += `?${$.param(filter)}`

    window.history.pushState({path: newUrl}, '', newUrl);
  }

  function filterBuilder() {
    var filter = {};
    var first_char = window.location.search.match('first_char=([^&#]*)');
    var query = window.location.search.match('query=([^&#]*)');

    if(first_char != null) filter.first_char = first_char[1];
    if(query != null) filter.query = query[1];

    return filter;
  }

  function infiniteScrollForTags() {
    var loading = false;
    var lastPageReached = false;
    var nextPageNumber = 1;
    var groupedTagsUrl = `/api/v1/grouped_tags${window.location.search}`;

    $('.wrapper.scroll').scroll(function(e) {
      var lastAlphabetTitle =  $('.tagGroupTitle').last().text();
      var scrollReachedEndOfDocument = ($('.tags-feed').height() - $(this).scrollTop()) < $(window).height() - 100;

      if(loading || lastPageReached) {
        return false;
      } else if(scrollReachedEndOfDocument) {
        loading = true;
        loadNextBatchOfTags();
      }

      function loadNextBatchOfTags() {
        $.get(groupedTagsUrl, { page: nextPageNumber + 1 }).then(function(response) {
          if($.isEmptyObject(response)) {
            lastPageReached = true;
          } else {
            $.each(response, function(char, tags) {
              var charTagsContent = '';

              if(lastAlphabetTitle == char) {
                $.each(tags, function(index, tag) {
                  charTagsContent += `<a class="tagsBadge" href="/tags/${tag.slug}">${tag.title}</a>`
                });

                charTagsContent += `
                    </div>
                  </div>
                `

                $('.charTags').last().append(charTagsContent);
              } else {
                charTagsContent += `
                  <div class="tagGroup clearfix">
                    <h2 class="tagGroupTitle">${char}</h2>
                    <div class="clearfix">
                `
                $.each(tags, function(index, tag) {
                  charTagsContent += `<a class="tagsBadge" href="/tags/${tag.slug}">${tag.title}</a>`
                });

                charTagsContent += `
                    </div>
                  </div>
                `

                lastAlphabetTitle = char;
                $('.tags-feed').append(charTagsContent);
              }
            });

            loading = false;
            nextPageNumber += 1;
          }
        });
      }
    });
  }
});
