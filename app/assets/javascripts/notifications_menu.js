$(function() {
  $(document).on('click', '.bell.active', function() {
    if($(this).hasClass('collapsed')) {
      $(this).removeClass('collapsed')
      console.log($(this).parent());
      console.log('open');
      getNotifications(1);
    } else {
      $(this).addClass('collapsed');
      console.log('closed');
    }
  });

  $(document).on('click', '.bell.active', function(e){
    e.stopPropagation();
    $(this).parent().toggleClass('bell-dropdown-open');
  });
  $(document).on('click', function() {
    $('.bell-dropdown-open').removeClass('bell-dropdown-open');
  });
  $(document).on('click', '.bell-dropdown-open .jq-dropdown', function(e){
    e.stopPropagation();
  });
  $('.profileDropdownHolder').mouseenter( function(){
    $('.bell-dropdown-open').removeClass('bell-dropdown-open');
  })

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
    console.log('asdasd')
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






