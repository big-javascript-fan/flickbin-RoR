$(function() {
  $('#user_channel_name').on('click', function() {
    $(this).removeAttr('placeholder');
  });

  $('#user_channel_name').on('focusout', function() {
    $(this).attr("placeholder", 'Enter your station name')
  });

  $('#user_email').on('click', function() {
    $(this).removeAttr('placeholder');
  });

  $('#user_email').on('focusout', function() {
    $(this).attr("placeholder", 'Enter your email')
  });

  $('#user_password').on('click', function() {
    $(this).removeAttr('placeholder');
  });

  $('#user_password').on('focusout', function() {
    $(this).attr("placeholder", 'Enter your password')
  });

  $('#user_channel_name').on('keydown', function(e) {
    var maxDescriptionLentgh = 30;
    var descriptionLentgh = $(this).val().length;
    if(descriptionLentgh <= maxDescriptionLentgh) {
      $('.rightNumber').text(maxDescriptionLentgh - descriptionLentgh);
    }
  });
});
