
/* All utility included there */

let utilities = {

    toggler: function(selector, className, self){
        event.preventDefault();
        $(selector).toggleClass(className);
    },
    counterIncrement: function(){
        event.preventDefault();
        $('.counterNumber').text(parseInt($('.counterNumber').text()) + 1);
    },
    counterDecrement: function(){
        event.preventDefault();
        $('.counterNumber').text(parseInt($('.counterNumber').text()) - 1)
    }

}
$(function(){
	$('.jq-dropdown').on('show', function(event, dropdownData) {
        console.log(dropdownData);
        $(dropdownData.jqDropdown).appendTo(document.body);
    }).on('hide', function(event, dropdownData) {
        console.log(dropdownData);
    });
});

$(function() {
    
    $(document).on('click', '.megamenu .dropdown-menu', function(e) {
      e.stopPropagation()
    });

    $('.offCanvasBtn').click(function(e){
        e.preventDefault();
        if($('html').hasClass('offCanvasOpen')){ $('html').removeClass('offCanvasOpen');}
        else { $('html').addClass('offCanvasOpen');}
    });

    $('.offCanvasMask').click(function(){
        $('html').removeClass('offCanvasOpen');
        e.preventDefault();
    });

 })
