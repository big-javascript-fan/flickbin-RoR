$(function() {


    $(".card-vote").click(function(e) {
        e.preventDefault()
        var self = this;
        
        var member = $(this).data('member');
        if (member == '1') {
            $.ajax({
                type: 'PUT',
                url: '/api/v1/battles',
                data: { value1: true }
            }).then( function() {
                $.get('/api/v1/battles').then(function(response) {
                    console.log(response);
                    $(self).html(response[0]);
                 });
            });         
           
        } else if (member == '2') {
            $.ajax({
                type: 'PUT',
                url: '/api/v1/battles',
                data: { value2: true }
            }).then( function() {
                $.get('/api/v1/battles').then(function(response) {
                    console.log(response);      
                    $(self).html(response[1]);
                 });
            });
        } else {
            alert("no");
        };        

        // $('.card-vote').parents('.card-fight').addClass('card-fight-selected')
        // $('.divider-button, .divider-button-mobile').removeClass('hidden')                
    });
});