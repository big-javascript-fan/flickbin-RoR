$(function() {
  $('a.rejectDestroyVideo').on('click', function(e) {
    e.preventDefault();
    $(this).closest( "div.removerBar").removeClass('removerBarActivated');
  });
});
