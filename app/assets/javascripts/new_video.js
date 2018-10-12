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
      } else {
        this.element.prop( "disabled", true );
      }
    }
  }

  if($('#video_url').val().length > 0) {
    videoUrlInput.filled = true;
  }

  if($('#video_tag_name').val().length > 0) {
    videoTagInput.filled = true;
  }

  $('#video_url').on('click', function() {
    $(this).parent().removeClass('errorMsg');
  });

  $('#video_url').on('keyup', function() {
    if($(this).val().length > 0) {
      videoUrlInput.filled = true;
    } else {
      videoUrlInput.filled = false;
    }
  });

  $('#video_tag_name').on('keyup', function() {
    var query = $(this).val();

    if(query.length > 0) {
      videoTagInput.filled = true;
      $(this).addClass('hasBorder');
      $.get('/api/v1/tags', { query: query }).then(function(response) {
        dropdownBuilder(response, query);
      });
    } else {
      videoTagInput.filled = false;
      $(this).removeClass('hasBorder')
      $('.dropdownItemListOuter').hide();
    }
  });

  function dropdownBuilder(data, query) {
    var dropdownContent = '';
    var createTagBtn = `
      <a href="#" class="createTagBtn">
        <span class="inlineAddCircle ">+</span> Create Tag ${query}
      </a>
    `
    if(data.length > 0) {
      $.each(data, function(index, tag) {
        dropdownContent += `
          <li>
            <a href="#" class="chooseTagBtn" tag_title="${tag.title}" tag_id="${tag.id}">
              ${tag.title} <span class="inlineAddCircle">+</span>
            </a>
          </li>
        `
      });
    }

    $('.dropdownItemList').html(dropdownContent);
    $('.createTagBtnHolder').html(createTagBtn);
    $('.dropdownItemListOuter').show();

    $('.chooseTagBtn').on('click', function(e) {
      e.preventDefault();

      var tagTitle = $(this).attr('tag_title');
      var tagId = $(this).attr('tag_id');

      $('.dropdownItemListOuter').hide();
      $('#video_tag_name').val(tagTitle);
      $('#video_tag_name').removeClass('hasBorder');
      $('#video_tag_id').val(tagId);
    });
  }
});
