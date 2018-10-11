$(function() {
  $('#video_url').on('keyup', function() {
    if($(this).val().length > 0 && $('#video_tag_id').val().length > 0) {
      $(this).parent().addClass('tagSelected');
      $('#post_video').prop( "disabled", false );
    } else if($(this).val().length > 0) {
      $(this).parent().addClass('tagSelected');
      $('#post_video').prop( "disabled", true );
    } else {
      $(this).parent().removeClass('tagSelected');
      $('#post_video').prop( "disabled", true );
    }
  });

  $('#video_tag_id').on('keyup', function() {
    if($(this).val().length > 0 && $('#video_url').val().length > 0) {
      $(this).parent().addClass('tagSelected');
      $('#post_video').prop( "disabled", false );
    } else if($(this).val().length > 0) {
      $(this).parent().addClass('tagSelected');
      $('#post_video').prop( "disabled", true );
    } else {
      $(this).parent().removeClass('tagSelected');
      $('#post_video').prop( "disabled", true );
    }
  });

  $('#video_url').on('click', function() {
    $(this).parent().removeClass('errorMsg');
  });
});
