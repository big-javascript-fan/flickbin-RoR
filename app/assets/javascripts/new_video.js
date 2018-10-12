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
    parentDiv: $('#video_tag_id').parent(),
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

  if($('#video_tag_id').val().length > 0) {
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

  $('#video_tag_id').on('keyup', function() {
    var query = $(this).val();

    if(query.length > 0) {
      videoTagInput.filled = true;
      $.get('/api/v1/tags', { query: query }).then(function(response) {
        dropdownBuilder(response, query);
      });
    } else {
      videoTagInput.filled = false;
      $('.dropdownItemListOuter').hide();
    }
  });

  function dropdownBuilder(data, query) {
    var dropdownContent = '';
    var createTagBtn = `
      <a href="#" class="createTagBtn">
        <span class="inlineAddCircle">+</span> Create Tag ${query}
      </a>
    `
    if(data.length > 0) {
      $.each(data, function(index, tag) {
        dropdownContent += `
          <li>
            <a href="#">
              ${tag.title} <span class="inlineAddCircle">+</span>
            </a>
          </li>
        `
      });
    }

    $('.dropdownItemList').html(dropdownContent);
    $('.createTagBtnHolder').html(createTagBtn);
    $('.dropdownItemListOuter').show();
  }
});
