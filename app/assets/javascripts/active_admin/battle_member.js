$(function() {
  if(window.location.href.match(/\/battle_members\/new/)) {
    $('#battle_member_youtube_channel_url').on('keyup', function(e) {
      if($('#battle_member_youtube_channel_url').val().match(/https:\/\/www.youtube.com\/channel\/[A-Za-z0-9]+/)) {
        $('#parse_youtube_channel_info').removeClass('no-click');
      } else {
        $('#parse_youtube_channel_info').addClass('no-click');
      }
    });

    $(document).on('click', '#parse_youtube_channel_info', function(e) {
      e.preventDefault();
      var url = $('#battle_member_youtube_channel_url').val();

      if(url) {
        $.get(`/api/v1/youtube_channels`, {
          youtube_channel_url: url
        }).then(function(response) {
          $('#battle_member_twitter_account').val(response.twitter_account);
          $('#battle_member_channel_title').val(response.channel_title);

          if(response.channel_avatar_url) {
            $('#battle_member_channel_avatar').val(response.channel_avatar_url);
            $('#channel_avatar_preview').html(`<img src="${response.channel_avatar_url}">`);
            $('#channel_avatar_preview').prepend('<label class="label">Channel avatar preview</label>');
          }
        });
      }
    });
  }
});
