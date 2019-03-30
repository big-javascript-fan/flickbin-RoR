$(function() {


    $(".card-vote").click(function(e) {
        e.preventDefault()
        
        var self = this;
        var member = $(this).data('member');
        var battleId = $(".section-fight").data('battle');
        var upvote = parseInt($(self).text()); 
        var error = " You can vote once every 24 hours"
        if (member == '1') {
            $.ajax({
                type: 'PUT',
                url:  `/api/v1/battles/${battleId}`,
                data: { value1: true },
                error: function(xhr, message) {
                    console.log(xhr.status);
                    console.log(xhr.statusText + error);
                    console.log(message);
                }
            }).then( function() {
                $(self).text(upvote + 1)               
            });         
           
        } else if (member == '2') {
            $.ajax({
                type: 'PUT',
                url: `/api/v1/battles/${battleId}`,
                data: { value2: true },
                error: function(xhr, message) {
                    console.log(xhr.status);
                    console.log(xhr.statusText + error);
                    console.log(message);
                }
            }).then( function() {
                $(self).text(upvote + 1)               
            });
        } else {
            alert("no");
        };                      
    }); 
        // $('.card-vote').parents('.card-fight').addClass('card-fight-selected')
        // $('.divider-button, .divider-button-mobile').removeClass('hidden')  
});