$(function() {
  $('a.rejectDestroyVideo').on('click', function(e) {
    e.preventDefault();
    $(this).closest( "div.removerBar").removeClass('removerBarActivated');
  });

  $('#user_channel_description').on('keyup', function(e) {
    var maxDescriptionLentgh = 160;
    var descriptionLentgh = $(this).val().length;
    if(descriptionLentgh <= maxDescriptionLentgh) {
      $('.rightNumber').text(maxDescriptionLentgh - descriptionLentgh);
    }
  });
});
