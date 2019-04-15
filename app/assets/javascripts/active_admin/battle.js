$(function(){
  var submitButton = $('#battle_submit_action input');
  toggle_submit_button();

  $('fieldset .input.required').on('change', function(e) {
    toggle_submit_button();
  });
  function toggle_submit_button() {
    let values =  $('select, .date-time-picker-input').map(function(){return $(this).val();}).get();
    if(values.includes("")) {
      submitButton.addClass('no-click');
    } else {
      submitButton.removeClass('no-click');
    }
  };
})
