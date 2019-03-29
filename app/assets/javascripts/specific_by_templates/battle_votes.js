$(function() {


    $(".card-vote").click(function(e) {
        e.preventDefault()
        
        var self = this;
        var member = $(this).data('member');
        var battleId = $(".section-fight").data('battle');
        var upvote = parseInt($(self).text());
        if (member == '1') {
            $.ajax({
                type: 'PUT',
                url:  `/api/v1/battles/${battleId}`,
                data: { value1: true }
            }).then( function(response) {
                response.status === 200 ? $(self).text(upvote + 1) : console.log(response.message);               
            });         
           
        } else if (member == '2') {
            $.ajax({
                type: 'PUT',
                url: `/api/v1/battles/${battleId}`,
                data: { value2: true }
            }).then( function(response) {
                response.status === 200 ? $(self).text(upvote + 1) : console.log(response.message);
            });
        } else {
            alert("no");
        };                      
    }); 
        // $('.card-vote').parents('.card-fight').addClass('card-fight-selected')
        // $('.divider-button, .divider-button-mobile').removeClass('hidden')  
});