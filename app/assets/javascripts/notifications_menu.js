$(function() {
  window.getNotifications = getNotifications;
  $(document).on('mouseenter', '.notificationDropdown', function(e){
    if(!$(this).hasClass('.bell-dropdown-open')){
      e.stopPropagation();
      getNotifications(1);
      $(this).addClass('bell-dropdown-open');
    }
  });
  $(document).on('mouseleave', '.notificationDropdown', function(e){
    if(e.target !== $('.jq-dropdown')){
      $(this).removeClass('bell-dropdown-open');        
    }
  });
  $(document).on('mouseenter', '.bell-dropdown-open .jq-dropdown', function(e){
    e.stopPropagation();
  });
  $('.profileDropdownHolder').mouseenter( function(){
    $('.bell-dropdown-open').removeClass('bell-dropdown-open');
  });
  $(document).on('click', '.notificationDropdown', function(e){
    if(window.innerWidth <= 640){
      $('.jq-dropdown-mobile').toggle('');
      $('.jq-dropdown-mobile').toggleClass('jq-mobile-open');

      if($('.jq-dropdown-mobile').hasClass('jq-mobile-open')){
        $('.notificationDropdown').removeClass('bell-dropdown-close-mobile');
        $('.notificationDropdown').addClass('bell-dropdown-open-mobile');
      }else{
        $('.notificationDropdown').removeClass('bell-dropdown-open-mobile');
        $('.notificationDropdown').addClass('bell-dropdown-close-mobile');
      }
    }
  });
  function getNotifications(currentPage) {
    var ids = [];

    $.get('/api/v1/notifications', { page: currentPage }, function(response) {
      var notificationsMenuHeader = '';
      var notificationsMenuContent = '';
      var notificationsMenuPagination = '';
      var totalPages = Array.from(Array(response.total_pages + 1).keys()).slice(1);

      notificationsMenuHeader = notificationHeaderBuilder(response);

      if(response.notifications.length > 0) {
        $.each(response.notifications, function(index, notification) {
          ids.push(notification.id);
          notificationsMenuContent += notificationBodyBuilder(notification);
        });
      }

      if(response.total_pages > 1) {
        notificationsMenuPagination += `
          <div class="notification notification-pagination">
            <a href="#" class="prev ${currentPage < 2 ? 'disabled' : ''}" onclick="getNotifications(${currentPage - 1})"><span class="icon icon-play_arrow"></span></a>
            <ul class="pagination-steps" >
        `

        $.each(totalPages, function(index, page) {
          notificationsMenuPagination += `
            <li class="${currentPage == page ? 'active' : ''}">
              <a href="#" class="pagination-step"></a>
            </li>
          `
        })

        notificationsMenuPagination += `
            </ul>
            <a href="#" class="next ${currentPage == response.total_pages ? 'disabled' : ''}" onclick="getNotifications(${currentPage + 1})"><span class="icon icon-play_arrow"></span></a>
          </div>
        `
      }

      if(response.total_unread_notifications < 4) {
        $('.notificationBadge').hide();
      }
      $('.notifications.dropdown-menu').empty();
      $('.notifications.dropdown-menu').append(notificationsMenuHeader);
      $('.notifications.dropdown-menu').append(notificationsMenuContent);
      $('.notifications.dropdown-menu').append(notificationsMenuPagination);
    }).done(function() {
      $.ajax({
        type: 'PUT',
        url: '/api/v1/notifications',
        data: { ids: ids }
      });
    });
  }
});

function notificationHeaderBuilder(response) {
  var notificationsMenuHeader = '';

  if (response.total_unread_notifications == 0) {
    notificationsMenuHeader += `
      <h2 class="heading-notification">No New Notifications</h2>
    `
  } else if(response.total_unread_notifications == 1) {
    notificationsMenuHeader += `
      <h2 class="heading-notification">${response.total_unread_notifications} New Notification</h2>
    `
  } else if(response.total_unread_notifications > 1) {
    notificationsMenuHeader += `
      <h2 class="heading-notification">${response.total_unread_notifications} New Notifications</h2>
    `
  }

  return notificationsMenuHeader;
}

function notificationBodyBuilder(notification) {
  var notificationsMenuContent = '';

  if(notification.category == 'comment_video') {
    notificationsMenuContent += `
      <a href="/videos/${notification.video.slug}?all_comments=true#comment_${notification.comment.id}" class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-message"></span>
            ${notification.commentator.channel_name} commented:
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            ${notification.comment.message}
          </p>
        </div>
      </a>
    `
  } else if(notification.category == 'reply_video_comment') {
    notificationsMenuContent += `
      <a href="/videos/${notification.video.slug}?all_comments=true#comment_${notification.comment.id}" class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-message"></span>
            ${notification.commentator.channel_name} replied:
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            ${notification.comment.message}
          </p>
        </div>
      </a>
    `
  } else if(notification.category == 'top_1_contributor') {
    notificationsMenuContent += `
      <div class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-star"></span>
            You're now the top contributor in the ${notification.tag.title} tag!
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            Flickbear says you're amazing!
          </p>
        </div>
      </div>
    `
  } else if(notification.category == 'top_3_contributors') {
    notificationsMenuContent += `
      <div class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-star"></span>
            You're top 3 in a ${notification.tag.title}!
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            <a href="/videos/new">You are now in the top 3 contributors on the ${notification.tag.title} tag. Keep posting and you could be in the top #1!</a>
          </p>
        </div>
      </div>
    `
  } else if(notification.category == 'top_5_contributors') {
    notificationsMenuContent += `
      <div class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-star"></span>
            You're top 10 in a ${notification.tag.title}!
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            <a href="/videos/new">You are now in the top 5 contributors on the ${notification.tag.title} tag. Keep up the good work and maybe soon, you'll be number one!</a>
          </p>
        </div>
      </div>
    `
  } else if(notification.category == 'top_10_contributors') {
    notificationsMenuContent += `
      <div class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-star"></span>
            You're top 10 in a ${notification.tag.title}!
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            <a href="/videos/new">You are now in the top 10 contributors on the ${notification.tag.title} tag. Keep posting and you could be in the top 3!</a>
          </p>
        </div>
      </div>
    `
  } else if(notification.category == 'top_1_video_in_tag') {
    notificationsMenuContent += `
      <div class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-star"></span>
            Congratulations!
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            <a href="/videos/${notification.video.slug}">Your Video "${notification.video.title}" is #1 on ${notification.tag.title}.</a>
          </p>
        </div>
      </div>
    `
  } else if(notification.category == 'top_10_videos_in_tag') {
    notificationsMenuContent += `
      <div class="notification message ${notification.read ? 'notification-read' : 'notification-unread'}">
        <div class="notification-header">
          <p class="notification-title">
            <span class="icon icon-star"></span>
            Congratulations!
          </p>
        </div>
        <div class="notification-body">
          <p class="notification-description">
            <a href="/videos/${notification.video.slug}">Your Video "${notification.video.title}" is climbing the charts and is now in the top ten in the ${notification.tag.title} tag.</a>
          </p>
        </div>
      </div>
    `
  }

  return notificationsMenuContent;
}


class Dropdown {
  constructor(selector) {
    this.selector = selector;
  }

  init() {
    let data = document.querySelectorAll(this.selector);
    let self = this;

    data.forEach( (item, index) => {
      document.addEventListener('click',function (e) {
      if ( e.target === item ) {
        self.toggle(item)
      } else if(e.target.parentElement == item.nextElementSibling || e.target == item.nextElementSibling){
        e.stopPropagation();
      } else {
        self.hide(item)
      }
    })
  })
  }

  toggle(item) {
    item.parentElement.classList.toggle('show');
    item.nextElementSibling.classList.toggle('show');
  }
  hide(item) {
    item.parentElement.classList.remove('show');
    item.nextElementSibling.classList.remove('show');
  }
}

let dropdown = new Dropdown('[data-toggle]');

dropdown.init();






