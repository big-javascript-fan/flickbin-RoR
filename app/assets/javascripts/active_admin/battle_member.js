$(function() {
  function toggle_parser_button() {
    if($('#battle_member_youtube_channel_url').val().match(/https:\/\/www.youtube.com\/channel\/[A-Za-z0-9]+/)) {
      $('#parse_youtube_channel_info').removeClass('no-click');
    } else {
      $('#parse_youtube_channel_info').addClass('no-click');
    }
  };
  toggle_parser_button();

  $('#battle_member_youtube_channel_url').on('keyup', function(e) {
    toggle_parser_button();
  });

  $(document).on('click', '#parse_youtube_channel_info', function(e) {
    e.preventDefault();
    var url = $('#battle_member_youtube_channel_url').val();

    if(url) {
      $.get(`/api/v1/youtube_channels`, {
        youtube_channel_url: url
      }).then(function(response) {
        $('#battle_member_twitter_account_name').val(response.twitter_account_name);
        $('#battle_member_name').val(response.name);

        if(response.photo_url) {
          $('#battle_member_photo_url').val(response.photo_url);
          $('#channel_avatar_preview').html(`<img src="${response.photo_url}">`);
          $('#channel_avatar_preview').prepend('<label class="label">Channel avatar preview</label>');
        }
      });
    }
  });
});
