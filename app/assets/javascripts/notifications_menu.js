$(function() {
  $(document).on('click', '.bell.active', function() {
    if($(this).hasClass('collapsed')) {
      $(this).removeClass('collapsed')
      console.log('open');
      getNotifications(1);
    } else {
      $(this).addClass('collapsed')
      console.log('closed');
    }
  });

  function getNotifications(page) {
    var ids = [];

    $.get('/api/v1/notifications', { page: page }, function(response) {
      if(response.notifications.length > 0) {
        $.each(response.notifications, function(index, notification) {
          ids.push(notification.id)
          console.log(notification)
        });
      }

      if(response.total_pages < 2) {
        $('.notificationBadge').hide();
        $('.bell.active').removeClass('active');
      }
    }).done(function() {
      $.ajax({
        type: 'PUT',
        url: '/api/v1/notifications',
        data: { ids: ids }
      });
    });
  }
});
