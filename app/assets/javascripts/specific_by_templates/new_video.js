$(function() {
  videoUrlInput = {
    parentDiv: $('#video_url').parent(),
    valid: false,
    set filled(flag) {
      if(flag == true) {
        this.valid = true;
        this.parentDiv.addClass('tagSelected');
      } else {
        this.valid = false;
        this.parentDiv.removeClass('tagSelected');
      }
      submitButton.validate();
    }
  };
  videoTagInput = {
    parentDiv: $('#video_tag_name').parent(),
    valid: false,
    set filled(flag) {
      if(flag == true) {
        this.valid = true;
        this.parentDiv.addClass('tagSelected');
      } else {
        this.valid = false;
        this.parentDiv.removeClass('tagSelected');
      }
      submitButton.validate();
    }

  };

  submitButton = {
    element: $('#post_video'),
    validate: function() {
      if(videoUrlInput.valid && videoTagInput.valid) {
        this.element.prop( "disabled", false );
        this.element.removeClass("disabled");
      } else {
        this.element.addClass("disabled");
        this.element.prop( "disabled", true );
      }
    }
  };




  if($('#video_url').val().length > 0) {
    videoUrlInput.filled = true;
  }
  if($('#video_tag_name').val().length > 0) {
    videoTagInput.filled = true;
  }

  $(document).on('click', function() {
    $('.videoUrlField.errorMsg').removeClass('errorMsg');
  });

  $('#video_url').on('click', function() {
    $(this).removeAttr('placeholder');
    $(this).closest("div.videoUrlField").removeClass('errorMsg');
  });

  $('#video_url').on('input keyup', function() {
    var self = this;
    var videoPlayers = ['youtube.', 'youtu.be', 'facebook.', 'dailymotion.', 'twitch.'];
    var findSubstring = function(str, substr) {
      if (str.indexOf(substr) != -1) {
        return substr;
      }
    };

    var getPlayer = videoPlayers.reduce(function (acum, item) {
      switch (findSubstring($(self).val(), item)) {
        case 'youtube.':
          acum = 'youtube';
          break;
        case 'youtu.be':
          acum = 'youtube';
          break;
        case 'facebook.':
          acum = 'facebook';
          break;
        case 'dailymotion.':
          acum = 'dailymotion';
          break;
        case 'twitch.':
          acum = 'twitch';
          break;
      }
      return acum
    }, '');

    $('.video-players-list .list-item').each(function (i, elem) {
      if (elem.dataset.media === getPlayer) {
        $(elem).addClass('active');
        $('.video-players-list').addClass('active');
        $('#nextstep').removeClass('disabled');
      } else {
        $(elem).removeClass('active');
      }
    });
    if(!$('.video-players-list .list-item').hasClass('active')){
      $('.video-players-list').removeClass('active');
      $('#nextstep').addClass('disabled');
    }
  });

  $('#nextstep').on('click', function(){
    if(!$(this).hasClass('disabled')){
      $('.section-video-post-first').removeClass('background-video-post');
      $('.section-video-post-secondary').addClass('background-video-post');
      $('.video-players-list').removeClass('active');
      $('.section-video-post-first .labelFields').addClass('labelFieldsChecked');
    }
  });

  $('#video_url').on('focusout', function() {
    $(this).attr("placeholder", 'https://www.youtube.com/watch?v=ABuQA13l-229');
  });

  $(document).on('keyup', '#video_url', function(e) {
    if($(this).val().length > 0) {
      videoUrlInput.filled = true;
    } else {
      videoUrlInput.filled = false;
    }
  });

  $(document).on('paste', '#video_url', function(e) {
    videoUrlInput.filled = true;
  });

  $('#video_tag_name').on('click', function() {
    $(this).removeAttr('placeholder');
  });

  $('#video_tag_name').on('focusout', function() {
    $(this).attr("placeholder", 'Add and Existing Tag or Create a New One')
  });

  $('#video_tag_name').on('keyup', function() {
    var maxTagTitleLentgh = 15;
    var regex = new RegExp("^[a-zA-Z0-9]+$");
    var query = $(this).val();

    if(query.length <= maxTagTitleLentgh) {
      $(this).siblings('span.rightNumber').text(maxTagTitleLentgh - query.length);
    }

    if(regex.test(query)) {
      $('.postVideoLastField').removeClass('errorMsg')
      videoTagInput.filled = false;

      if(query.length > 0 && regex.test(query)) {
        $(this).addClass('hasBorder');
        $.get('/api/v1/tags', { query: query }).then(function(response) {
          dropdownBuilder(response, query);
        });
      } else {
        $(this).removeClass('hasBorder')
        $('.dropdownItemListOuter').hide();
      }
    }  else if(query.length > 0) {
      $('.dropdownItemListOuter').hide();
      $('.postVideoLastField').addClass('errorMsg')
    } else {
      $('.tagNameField.errorMsg').removeClass('errorMsg');
      $('.dropdownItemListOuter').hide();
    }
  });

  function dropdownBuilder(data) {
    var query = $('#video_tag_name').val();
    var dropdownContent = '';
    var newTag = true;
    var createTagBtn = `
      <a href="#" class="createTagBtn" tag_title="${query.toLowerCase()}">
        <span class="inlineAddCircle ">+</span> Create Tag "${query.toLowerCase()}"
      </a>
    `
    if(data.length > 0) {
      $.each(data, function(index, tag) {
        if(newTag == true && tag.title == query.toLowerCase()) newTag = false;

        dropdownContent += `
          <li>
            <a href="#" class="chooseTagBtn" tag_title="${tag.title.toLowerCase()}" tag_id="${tag.id}">
              <span class="existingTagSuggestion">${tag.title.toLowerCase()}</span><span class="inlineAddCircle">+</span>
            </a>
          </li>
        `
      });
    }

    $('.dropdownItemList').html(dropdownContent);
    $('.createTagBtnHolder').html(newTag == true ? createTagBtn : '');
    $('.dropdownItemListOuter').show();

    $('.chooseTagBtn').on('click', function(e) {
      e.preventDefault();

      var tagTitle = $(this).attr('tag_title');
      var tagId = $(this).attr('tag_id');

      $('.dropdownItemListOuter').hide();
      $('#video_tag_name').val(tagTitle);
      $('#video_tag_name').removeClass('hasBorder');
      $('#video_tag_id').val(tagId);
      videoTagInput.filled = true;
    });

    $('.createTagBtn').on('click', function(e) {
      e.preventDefault();
      var tagTitle = $(this).attr('tag_title');

      $.post('/api/v1/tags', { title: tagTitle }).then(function(response) {
        $('.dropdownItemListOuter').hide();
        $('#video_tag_name').val(tagTitle);
        $('#video_tag_name').removeClass('hasBorder');
        $('#video_tag_id').val(response.id);
        videoTagInput.filled = true;
      });
    });
  }
  function setPageHeight() {
    var mediaQuery = 768;
    var viewPortHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    var viewPortWidth = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    var pageContainerStyles = "overflow: hidden;";
    if (viewPortWidth > mediaQuery) {
      $('.newVideoPageContainer').css({'height': viewPortHeight + "px", 'overflow': 'hidden'});
    } else {
      $('.siteFooter').css({'display': 'none'});
    }
  };
  setPageHeight();
});
